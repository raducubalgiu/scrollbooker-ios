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
    
    private let getUserProfile: GetUserProfileUseCase
    private let username: String
    
    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(username: String, getUserProfile: GetUserProfileUseCase) {
        self.username = username
        self.getUserProfile = getUserProfile
    }
    
    func loadProfile() async {
        guard uiState.data == nil else { return }
        
        uiState.errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getUserProfile(username: username)
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
            let result = try await getUserProfile(username: username)
            uiState.data = result
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            
            uiState.errorMessage = message
        }
        
        uiState.isRefreshing = false
    }
}
