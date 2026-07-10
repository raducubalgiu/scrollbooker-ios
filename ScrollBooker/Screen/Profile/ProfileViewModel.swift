//
//  ProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//


import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel: HasLoadingState {
    var uiState = UiState(data: UserProfile?.none)
    
    private let session: SessionManager
    private let getUserProfileUseCase: GetUserProfileUseCase
    
    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(session: SessionManager, getUserProfileUseCase: GetUserProfileUseCase) {
        self.session = session
        self.getUserProfileUseCase = getUserProfileUseCase
    }
        
    func loadProfile() async {
        guard uiState.data == nil else { return }
        
        uiState.errorMessage = nil
        
        do {
            guard let username = session.userInfo?.username else {
                uiState.errorMessage = "Username not found"
                return
            }
            
            let result = try await withVisibleLoading {
                try await getUserProfileUseCase(username: username)
            }
            
            uiState.data = result
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
        }
    }
    
    func refresh() async {
        guard !uiState.isRefreshing else { return }
        
        uiState.isRefreshing = true
        uiState.errorMessage = nil
        
        do {
            guard let username = session.userInfo?.username else {
                uiState.errorMessage = "Username not found"
                return
            }
            
            let result = try await getUserProfileUseCase(username: username)
            uiState.data = result
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
        }
        
        uiState.isRefreshing = false
    }
}
