//
//  BookingViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation
import Observation

enum BookingFlowState: Equatable {
    case idle
    case loading
    case success(BookingFlow)
    case error(String)
    
    var bookingFlow: BookingFlow? {
        if case .success(let bookingFlow) = self { return bookingFlow }
        return nil
    }
}

@Observable
@MainActor
final class BookingViewModel: HasLoadingState {
    private(set) var viewState: BookingFlowState = .idle
    
    let params: BookingNavigationParams
    private let getBookingFlowUseCase: GetBookingFlowUseCase
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    private(set) var selectedBookingItems: [SelectedBookingItem] = []
    
    var isLoading: Bool {
        get {
            if case .loading = viewState { return true }
            return isPerformingAction
        }
        set { isPerformingAction = newValue }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return operationErrorMessage
        }
        set { operationErrorMessage = newValue }
    }
    
    var selectedEmployeeId: Int?
    
    private var isEmployee: Bool {
        params.userId != params.businessOwnerId
    }
    
    var shouldSelectSpecialist: Bool {
        guard case .success(let bookingFlow) = viewState else { return false }
        return bookingFlow.business.hasEmployees && !isEmployee
    }
    
    var bookingTotals: BookingTotals {
        let sumPrice = selectedBookingItems.reduce(Decimal(0)) { total, item in
            if let employeeId = selectedEmployeeId {
                let specificOffering = item.offerings.first(where: { $0.user.id == employeeId })
                return total + (specificOffering?.priceWithDiscount ?? 0)
            } else {
                return total + (item.offerings.first?.priceWithDiscount ?? 0)
            }
        }
        
        let sumDuration = selectedBookingItems.reduce(0) { total, item in
            total + item.variantDuration
        }
        
        return BookingTotals(totalPrice: sumPrice, totalDuration: sumDuration)
    }
    
    init(
        params: BookingNavigationParams,
        getBookingFlowUseCase: GetBookingFlowUseCase
    ) {
        self.params = params
        self.getBookingFlowUseCase = getBookingFlowUseCase
        
        if params.userId != params.businessOwnerId {
            self.selectedEmployeeId = params.userId
        } else {
            self.selectedEmployeeId = nil
        }
    }
    
    func loadBookingFlow() async {
        guard viewState.bookingFlow == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        operationErrorMessage = nil
        
        let employeeId = isEmployee ? params.userId : nil
        
        do {
            let result = try await withVisibleLoading {
                try await getBookingFlowUseCase(
                    businessId: params.businessId,
                    employeeId: employeeId
                )
            }
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func setSelectedEmployeeId(_ id: Int) {
        self.selectedEmployeeId = id
    }
    
    func selectBookingItem(_ item: SelectedBookingItem) {
        if let index = selectedBookingItems.firstIndex(where: { $0.productId == item.productId }) {
            let existingItem = selectedBookingItems[index]
            
            if existingItem.variantId == item.variantId {
                selectedBookingItems.remove(at: index)
            } else {
                selectedBookingItems[index] = item
            }
        } else {
            selectedBookingItems.append(item)
        }
    }
    
    func removeBookingItem(_ item: SelectedBookingItem) {
        if let index = selectedBookingItems.firstIndex(where: { $0.productId == item.productId }) {
            selectedBookingItems.remove(at: index)
            
            if selectedBookingItems.isEmpty {
                self.selectedEmployeeId = nil
            }
        }
    }
}

