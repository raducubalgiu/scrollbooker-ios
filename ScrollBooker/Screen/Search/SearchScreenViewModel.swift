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

@Observable
@MainActor
final class SearchViewModel: HasLoadingState {
    private(set) var viewState: SearchBusinessesState = .idle
    private(set) var businesses: [BusinessSheet] = []
    private(set) var markers: [BusinessMarker] = []
    private(set) var totalCount = 0

    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil

    private let getBusinessesSheetUseCase: GetBusinessesSheetUseCase
    private let getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase
    private let getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase

    private var page = 1
    private let limit = 20

    var currentBBox: BusinessBoundingBox? = nil
    var currentZoom: Float = 10.0

    var selectedServiceId: Int? = nil
    var selectedBusinessDomainId: Int? = nil
    var selectedStartDate: String? = nil
    var selectedStartTime: String? = nil
    var selectedEndTime: String? = nil
    var maxPrice: Decimal? = nil
    var hasDiscount: Bool = false
    var currentSort: String? = "recommended"

    // MARK: - Dedup pentru search-ul declanșat de mișcarea hărții.
    // Mutat din View: e o decizie de business ("merită să caut din nou aici?"),
    // nu o stare de UI.
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
    /// Folosit de UI ca să știe când să înlocuiască toată lista cu skeleton-uri,
    /// spre deosebire de `isPaging`, care trebuie tratat separat printr-un loader
    /// mic la coada listei — nu prin re-randarea întregii liste.
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

    func triggerSearch(bbox: BusinessBoundingBox, zoom: Float, force: Bool = false) async {
        let center = CLLocationCoordinate2D(
            latitude: Double(bbox.minLat + bbox.maxLat) / 2,
            longitude: Double(bbox.minLng + bbox.maxLng) / 2
        )

        // REPARAT: Dacă force este true, NU mai verificăm dacă harta s-a mișcat
        if !force {
            guard shouldSearch(center: center, zoom: zoom) else { return }
        }

        // Actualizăm coordonatele ultimei căutări
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

        let requestDto = SearchBusinessRequest(
            bbox: bbox,
            zoom: currentZoom,
            maxMarkers: 100,
            businessDomainId: selectedBusinessDomainId,
            serviceDomainId: nil,
            serviceId: selectedServiceId,
            subFilterIds: nil,
            userLocation: nil,
            maxPrice: maxPrice,
            sort: currentSort,
            hasDiscount: hasDiscount,
            startDate: selectedStartDate,
            startTime: selectedStartTime,
            endTime: selectedEndTime
        )

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
}
