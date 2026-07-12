//
//  ProfileController.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileController: HasLoadingState {
    var uiState = UiState(data: UserProfile?.none)
    private(set) var viewState: ProfileState = .idle
    
    var isLoading: Bool {
        get {
            if case .loading = viewState { return true }
            return uiState.isLoading
        }
        set {
            uiState.isLoading = newValue
        }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return uiState.errorMessage
        }
        set {
            uiState.errorMessage = newValue
        }
    }
    
    private let getUserProfileUseCase: GetUserProfileUseCase
    
    init(getUserProfileUseCase: GetUserProfileUseCase) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    func fetchProfile(username: String, hasMinLoading: Bool = false) async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }
        
        if hasMinLoading {
            await withVisibleLoading {
                await performFetch(username: username)
            }
        } else {
            await performFetch(username: username)
        }
    }
    
    private func performFetch(username: String) async {
        viewState = .loading
        uiState.errorMessage = nil
        
        do {
            let result = try await getUserProfileUseCase(username: username)
            uiState.data = result
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func refreshProfile(username: String) async {
        guard !uiState.isRefreshing else { return }
        
        uiState.isRefreshing = true
        uiState.errorMessage = nil
        
        do {
            let result = try await getUserProfileUseCase(username: username)
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
