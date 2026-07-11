//
//  ProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//


import Foundation
import Observation

enum ProfileState: Equatable {
    case idle
    case loading
    case success(UserProfile)
    case error(String)
}

@Observable
@MainActor
final class ProfileViewModel: HasLoadingState {
    var uiState = UiState(data: UserProfile?.none)

    private(set) var viewState: ProfileState = .idle    
    private let session: SessionManager
    private let getUserProfileUseCase: GetUserProfileUseCase
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(session: SessionManager, getUserProfileUseCase: GetUserProfileUseCase) {
        self.session = session
        self.getUserProfileUseCase = getUserProfileUseCase
    }
        
    func loadProfile() async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        uiState.errorMessage = nil
        
        guard let username = session.userInfo?.username else {
            viewState = .error("Username not found")
            return
        }
        
        do {
            let result = try await getUserProfileUseCase(username: username)
            
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
        
        guard let username = session.userInfo?.username else {
            uiState.errorMessage = "Username not found"
            uiState.isRefreshing = false
            return
        }
        
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
