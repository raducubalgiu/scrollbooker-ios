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
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    let params: BookingNavigationParams
    private let getBookingFlowUseCase: GetBookingFlowUseCase
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return isPerformingAction }
        set { isPerformingAction = newValue }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return operationErrorMessage
        }
        set { operationErrorMessage = newValue }
    }
    
    init(
        params: BookingNavigationParams,
        getBookingFlowUseCase: GetBookingFlowUseCase
    ) {
        self.params = params
        self.getBookingFlowUseCase = getBookingFlowUseCase
    }
}
