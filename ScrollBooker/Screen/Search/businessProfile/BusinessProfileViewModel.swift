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
}

@Observable
@MainActor
final class BusinessProfileViewModel: HasLoadingState {
    var uiState = UiState(data: BusinessProfile?.none)
    private(set) var viewState: BusinessProfileState = .idle
    
    private let username: String
    private let getBusinessProfileUseCase: GetBusinessProfileUseCase
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(
        username: String,
        getBusinessProfileUseCase: GetBusinessProfileUseCase
    ) {
        self.username = username
        self.getBusinessProfileUseCase = getBusinessProfileUseCase
    }
    
    func loadBusinessProfile() async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        uiState.errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getBusinessProfileUseCase(username: username)
            }
            uiState.data = result
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func refresh() async {
        guard !uiState.isRefreshing else { return }
        uiState.isRefreshing = true
        uiState.errorMessage = nil
        
        do {
            let result = try await getBusinessProfileUseCase(username: username)
            uiState.data = result
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if uiState.data == nil {
                viewState = .error(message)
            } else {
                uiState.errorMessage = message
            }
        }
        uiState.isRefreshing = false
    }
}
