//
//  SearchScreenViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation
import Observation
import CoreLocation
import OSLog

struct SearchFilters: Equatable {
    var businessDomainId: Int? = 1
    var serviceDomainId: Int? = nil
    var serviceId: Int? = nil
    var subFilterIds: [Int]? = nil
    var maxPrice: Decimal? = nil
    var hasDiscount: Bool = false
    var sort: String? = "recommended"
    var startDate: String? = nil
    var startTime: String? = nil
    var endTime: String? = nil

    mutating func clear() {
        self = SearchFilters()
    }
}

extension SearchFilters {
    private static let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var dateTimeSummary: String {
        let datePart: String? = startDate.flatMap { dateString in
            Self.isoDateFormatter.date(from: dateString)?.formatted(.dateTime.day().month(.abbreviated))
        }

        let timePart: String? = {
            guard let startTime, let endTime else { return nil }
            return "\(startTime) – \(endTime)"
        }()

        switch (datePart, timePart) {
        case (let date?, let time?):
            return "\(date) • \(time)"
        case (let date?, nil):
            return date
        case (nil, let time?):
            return time
        case (nil, nil):
            return String(localized: "anytimeAnyHour")
        }
    }
}

@Observable
@MainActor
final class SearchViewModel {
    private(set) var viewState: FeatureState<[BusinessSheet]> = .idle
    var businesses: [BusinessSheet] { viewState.data ?? [] }

    private(set) var markers: [BusinessMarker] = []
    private(set) var businessDomains: [BusinessDomain] = []
    private(set) var totalCount = 0
    private(set) var recentSearchesState: FeatureState<[RecentSearch]> = .idle
    private(set) var servicesState: FeatureState<[ServiceWithFilters]> = .idle

    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Search")

    private let getBusinessesSheetUseCase: GetBusinessesSheetUseCase
    private let getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase
    private let getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase
    private let getRecentSearchesUseCase: GetRecentSearchesUseCase
    private let getServicesByServiceDomainUseCase: GetServicesByServiceDomainUseCase
    private let userLocationService: UserLocationService

    private var page = 1
    private let limit = 20
    private var isInitialized = false

    var currentBBox: BusinessBoundingBox? = nil
    var currentZoom: Float = 10.0

    var filters = SearchFilters()

    private var lastSearchedCenter: CLLocationCoordinate2D?
    private var lastSearchedZoom: Float?
    private var searchTask: Task<Void, Never>?

    private let minZoomDelta: Float = 0.5
    private let minMoveMeters: Double = 10000.0

    var hasMore: Bool {
        businesses.count < totalCount
    }

    /// Adevărat DOAR la încărcarea inițială a unei căutări (nu și în timpul paginării).
    var isInitialLoading: Bool {
        viewState == .loading
    }

    init(
        getBusinessesSheetUseCase: GetBusinessesSheetUseCase,
        getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase,
        getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase,
        getRecentSearchesUseCase: GetRecentSearchesUseCase,
        getServicesByServiceDomainUseCase: GetServicesByServiceDomainUseCase,
        userLocationService: UserLocationService
    ) {
        self.getBusinessesSheetUseCase = getBusinessesSheetUseCase
        self.getBusinessesMarkersUseCase = getBusinessesMarkersUseCase
        self.getAllBusinessDomainsUseCase = getAllBusinessDomainsUseCase
        self.getRecentSearchesUseCase = getRecentSearchesUseCase
        self.getServicesByServiceDomainUseCase = getServicesByServiceDomainUseCase
        self.userLocationService = userLocationService
    }

    func loadServices(serviceDomainId: Int) async {
        servicesState = .loading

        do {
            let services = try await withLoading {
                try await getServicesByServiceDomainUseCase(serviceDomainId: serviceDomainId)
            }
            servicesState = .success(services)
        } catch {
            servicesState = .error(logger.userMessage(for: error, context: "Loading Services"))
        }
    }

    func resetServicesState() {
        servicesState = .idle
    }

    func applyFilters(_ newFilters: SearchFilters) {
        filters = newFilters

        if newFilters.serviceDomainId != nil {
            recentSearchesState = .idle
        }
    }

    private let defaultMaxPrice: Decimal = 1500

    var activeFiltersCount: Int {
        let sortValue = filters.sort ?? SearchSortEnum.recommended.rawValue

        return [
            filters.hasDiscount,
            (filters.maxPrice ?? defaultMaxPrice) != defaultMaxPrice,
            sortValue != SearchSortEnum.recommended.rawValue
        ].filter { $0 }.count
    }

    var selectedServicesText: String {
        if filters.serviceDomainId == nil && filters.serviceId == nil {
            return String(localized: "allServices")
        }

        let domain = businessDomains
            .flatMap { $0.serviceDomains }
            .first { $0.id == filters.serviceDomainId }

        let domainName = domain?.name ?? String(localized: "services")

        if let serviceId = filters.serviceId,
           let serviceName = servicesState.data?.first(where: { $0.id == serviceId })?.name {
            return "\(domainName) – \(serviceName)"
        }

        return domainName
    }

    func loadRecentSearchesIfNeeded() async {
        guard recentSearchesState == .idle else { return }
        recentSearchesState = .loading

        do {
            let searches = try await withLoading {
                try await getRecentSearchesUseCase()
            }
            recentSearchesState = .success(searches)
        } catch {
            recentSearchesState = .error(logger.userMessage(for: error, context: "Loading Recent Searches"))
        }
    }

    func loadBusinessDomainsIfNeeded() async {
        guard businessDomains.isEmpty else { return }

        do {
            businessDomains = try await getAllBusinessDomainsUseCase()
        } catch {
            logger.error("ERROR: on Loading Business Domains: \(error.localizedDescription, privacy: .public)")
        }
    }

    func initializeScreen(bbox: BusinessBoundingBox, zoom: Float) async {
        guard !isInitialized else { return }
        isInitialized = true

        self.currentBBox = bbox
        self.currentZoom = zoom

        let center = CLLocationCoordinate2D(
            latitude: Double(bbox.minLat + bbox.maxLat) / 2,
            longitude: Double(bbox.minLng + bbox.maxLng) / 2
        )
        lastSearchedCenter = center
        lastSearchedZoom = zoom

        viewState = .loading
        operationErrorMessage = nil

        let requestDto = await createRequestDto(bbox: bbox, zoom: zoom)

        async let recentSearchesPrefetch: Void = loadRecentSearchesIfNeeded()

        do {
            let (domainsResponse, sheetResponse, markersResponse) = try await withLoading {
                async let domainsTask = getAllBusinessDomainsUseCase()
                async let sheetTask = getBusinessesSheetUseCase(page: 1, limit: self.limit, request: requestDto)
                async let markersTask = getBusinessesMarkersUseCase(request: requestDto)
                return try await (domainsTask, sheetTask, markersTask)
            }

            self.businessDomains = domainsResponse
            self.markers = markersResponse
            totalCount = sheetResponse.count

            page = 2

            viewState = .success(sheetResponse.results)

        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Initializing Search Screen"))
            self.markers = []
        }

        await recentSearchesPrefetch
    }

    func triggerSearch(bbox: BusinessBoundingBox, zoom: Float, force: Bool = false) async {
        let center = CLLocationCoordinate2D(
            latitude: Double(bbox.minLat + bbox.maxLat) / 2,
            longitude: Double(bbox.minLng + bbox.maxLng) / 2
        )

        if !force {
            guard shouldSearch(center: center, zoom: zoom) else { return }
        }

        lastSearchedCenter = center
        lastSearchedZoom = zoom

        self.currentBBox = bbox
        self.currentZoom = zoom

        searchTask?.cancel()
        let task = Task {
            if !force {
                try? await Task.sleep(for: .milliseconds(300))
                guard !Task.isCancelled else { return }
            }

            self.page = 1
            await self.load(isFirstPage: true)
        }
        searchTask = task
        await task.value
    }

    private func shouldSearch(center: CLLocationCoordinate2D, zoom: Float) -> Bool {
        guard let lastCenter = lastSearchedCenter, let lastZoom = lastSearchedZoom else {
            return true
        }

        if abs(lastZoom - zoom) >= minZoomDelta {
            return true
        }

        let lastLocation = CLLocation(latitude: lastCenter.latitude, longitude: lastCenter.longitude)
        let newLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)

        return lastLocation.distance(from: newLocation) >= minMoveMeters
    }

    func refresh() async {
        guard !isRefreshing, currentBBox != nil else { return }
        isRefreshing = true

        page = 1
        await load(isFirstPage: true)

        isRefreshing = false
    }

    func loadMoreIfNeeded(currentBusiness: BusinessSheet?) async {
        guard hasMore, !isPaging, !isRefreshing, viewState != .loading else { return }

        guard let current = currentBusiness,
              current.id == businesses.last?.id
        else { return }

        isPaging = true
        defer { isPaging = false }

        await load(isFirstPage: false)
    }

    private func load(isFirstPage: Bool) async {
        guard let bbox = currentBBox else { return }

        if isFirstPage && !isRefreshing {
            viewState = .loading
        }

        operationErrorMessage = nil
        let requestDto = await createRequestDto(bbox: bbox, zoom: currentZoom)

        do {
            if isFirstPage {
                let (sheetResponse, markersResponse) = try await withLoading {
                    async let sheetTask = getBusinessesSheetUseCase(page: self.page, limit: self.limit, request: requestDto)
                    async let markersTask = getBusinessesMarkersUseCase(request: requestDto)
                    return try await (sheetTask, markersTask)
                }

                try Task.checkCancellation()

                self.markers = markersResponse
                totalCount = sheetResponse.count
                viewState = .success(sheetResponse.results)
            } else {
                let response = try await getBusinessesSheetUseCase(page: self.page, limit: self.limit, request: requestDto)

                try Task.checkCancellation()

                let existingIds = Set(businesses.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                totalCount = response.count
                viewState = .success(businesses + unique)
            }

            page += 1

        } catch is CancellationError {
            // O căutare mai nouă a preluat deja acest task — ignorăm rezultatul învechit.
            return
        } catch {
            guard !Task.isCancelled else { return }

            let message = logger.userMessage(for: error, context: "Loading Business Sheets page \(page) (FirstPage: \(isFirstPage))")

            if isFirstPage {
                viewState = .error(message)
                self.markers = []
            } else {
                operationErrorMessage = message
            }
        }
    }

    /// Helper privat menit să unifice și să curețe instanțierea DTO-ului către server.
    private func createRequestDto(bbox: BusinessBoundingBox, zoom: Float) async -> SearchBusinessRequest {
        let userLocation = await userLocationService.currentLocation()

        return SearchBusinessRequest(
            bbox: bbox,
            userLocation: userLocation,
            zoom: zoom,
            maxMarkers: 100,
            businessDomainId: filters.businessDomainId,
            serviceDomainId: filters.serviceDomainId,
            serviceId: filters.serviceId,
            subFilterIds: filters.subFilterIds,
            maxPrice: filters.maxPrice,
            sort: filters.sort,
            hasDiscount: filters.hasDiscount,
            startDate: filters.startDate,
            startTime: filters.startTime,
            endTime: filters.endTime
        )
    }
}
