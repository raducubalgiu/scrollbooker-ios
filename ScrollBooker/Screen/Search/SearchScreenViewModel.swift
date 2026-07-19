//
//  SearchScreenViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation
import Observation
import CoreLocation

enum SearchBusinessesState {
    case idle
    case loading
    case empty
    case success([BusinessSheet])
    case error(String)
}

struct SearchFilters: Equatable {
    var businessDomainId: Int? = nil
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

@Observable
@MainActor
final class SearchViewModel: HasLoadingState {
    private(set) var viewState: SearchBusinessesState = .idle
    private(set) var businesses: [BusinessSheet] = []
    private(set) var markers: [BusinessMarker] = []
    private(set) var businessDomains: [BusinessDomain] = []
    private(set) var totalCount = 0

    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil

    private let getBusinessesSheetUseCase: GetBusinessesSheetUseCase
    private let getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase
    private let getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase

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

    var isLoading: Bool {
        get {
            if case .loading = viewState { return true }
            return isPaging
        }
        set {
            if newValue && !isPaging && !isRefreshing {
                viewState = .loading
            }
        }
    }

    /// Adevărat DOAR la încărcarea inițială a unei căutări (nu și în timpul paginării).
    var isInitialLoading: Bool {
        if case .loading = viewState { return true }
        return false
    }

    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return operationErrorMessage
        }
        set {
            if let msg = newValue {
                if businesses.isEmpty {
                    viewState = .error(msg)
                } else {
                    operationErrorMessage = msg
                }
            }
        }
    }

    init(
        getBusinessesSheetUseCase: GetBusinessesSheetUseCase,
        getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase,
        getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase
    ) {
        self.getBusinessesSheetUseCase = getBusinessesSheetUseCase
        self.getBusinessesMarkersUseCase = getBusinessesMarkersUseCase
        self.getAllBusinessDomainsUseCase = getAllBusinessDomainsUseCase
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
        
        let requestDto = createRequestDto(bbox: bbox, zoom: zoom)
        
        do {
            let (domainsResponse, sheetResponse, markersResponse) = try await withVisibleLoading {
                async let domainsTask = getAllBusinessDomainsUseCase()
                async let sheetTask = getBusinessesSheetUseCase(page: 1, limit: self.limit, request: requestDto)
                async let markersTask = getBusinessesMarkersUseCase(request: requestDto)
                return try await (domainsTask, sheetTask, markersTask)
            }
            
            self.businessDomains = domainsResponse
            self.businesses = sheetResponse.results
            self.markers = markersResponse
            totalCount = sheetResponse.count
            
            page = 2
            
            if businesses.isEmpty {
                viewState = .empty
            } else {
                viewState = .success(businesses)
            }
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            
            viewState = .error(message)
            self.businesses = []
            self.markers = []
        }
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
        guard hasMore, !isPaging, !isRefreshing else { return }
        if case .loading = viewState { return }

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
        let requestDto = createRequestDto(bbox: bbox, zoom: currentZoom)

        do {
            if isFirstPage {
                let (sheetResponse, markersResponse) = try await withVisibleLoading {
                    async let sheetTask = getBusinessesSheetUseCase(page: self.page, limit: self.limit, request: requestDto)
                    async let markersTask = getBusinessesMarkersUseCase(request: requestDto)
                    return try await (sheetTask, markersTask)
                }

                self.businesses = sheetResponse.results
                self.markers = markersResponse
                totalCount = sheetResponse.count
            } else {
                let response = try await getBusinessesSheetUseCase(page: self.page, limit: self.limit, request: requestDto)

                let existingIds = Set(businesses.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                self.businesses.append(contentsOf: unique)
                totalCount = response.count
            }

            page += 1

            if businesses.isEmpty {
                viewState = .empty
            } else {
                viewState = .success(businesses)
            }

        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription

            if isFirstPage {
                viewState = .error(message)
                self.businesses = []
                self.markers = []
            } else {
                operationErrorMessage = message
                print("Eroare la încărcarea paginii \(page) de business sheets: \(message)")
            }
        }
    }
    
    /// Helper privat menit să unifice și să curețe instanțierea DTO-ului către server.
    private func createRequestDto(bbox: BusinessBoundingBox, zoom: Float) -> SearchBusinessRequest {
        SearchBusinessRequest(
            bbox: bbox,
            userLocation: nil,
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

