//
//  SearchScreenViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation
import Observation

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
    
    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil

    private let getBusinessesSheetUseCase: GetBusinessesSheetUseCase
    private let getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase
    
    private var page = 1
    private let limit = 20
    private var totalCount = 0

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

    var hasMore: Bool {
        businesses.count < totalCount
    }

    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return isPaging }
        set { if newValue && !isPaging { viewState = .loading } }
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
        getBusinessesMarkersUseCase: GetBusinessesMarkersUseCase
    ) {
        self.getBusinessesSheetUseCase = getBusinessesSheetUseCase
        self.getBusinessesMarkersUseCase = getBusinessesMarkersUseCase
    }

    func triggerSearch(bbox: BusinessBoundingBox, zoom: Float) async {
        self.currentBBox = bbox
        self.currentZoom = zoom
        
        page = 1
        await load(isFirstPage: true)
    }

    func refresh() async {
        guard !isRefreshing, currentBBox != nil else { return }
        isRefreshing = true
        
        page = 1
        await load(isFirstPage: true)
        
        isRefreshing = false
    }

    func loadMoreIfNeeded(currentBusiness: BusinessSheet?) async {
        guard hasMore, !isPaging, !isRefreshing, !isLoading else { return }
        
        guard let current = currentBusiness,
              current.id == businesses.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false)
        isPaging = false
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
                let response = try await withVisibleLoading {
                    try await getBusinessesSheetUseCase(page: self.page, limit: self.limit, request: requestDto)
                }
                
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
