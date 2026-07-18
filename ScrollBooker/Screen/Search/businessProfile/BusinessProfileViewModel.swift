//
//  BusinessProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation
import Observation

enum BusinessProfileState: Equatable {
    case idle
    case loading
    case success(BusinessProfile)
    case error(String)
    
    var profile: BusinessProfile? {
        if case .success(let profile) = self { return profile }
        return nil
    }
}

@Observable
@MainActor
final class BusinessProfileViewModel: HasLoadingState {
    private(set) var viewState: BusinessProfileState = .idle
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private let username: String
    private let getBusinessProfileUseCase: GetBusinessProfileUseCase
    
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
        username: String,
        getBusinessProfileUseCase: GetBusinessProfileUseCase
    ) {
        self.username = username
        self.getBusinessProfileUseCase = getBusinessProfileUseCase
    }
    
    func loadBusinessProfile() async {
        guard viewState.profile == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        operationErrorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getBusinessProfileUseCase(username: username)
            }
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        operationErrorMessage = nil
        
        do {
            let result = try await getBusinessProfileUseCase(username: username)
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            
            if viewState.profile == nil {
                viewState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
        isRefreshing = false
    }
}
