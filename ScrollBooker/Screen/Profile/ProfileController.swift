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
final class ProfileController {
    var uiState = UiState(data: UserProfile?.none)
    private(set) var viewState: ProfileState = .idle
    
    private let getUserProfileUseCase: GetUserProfileUseCase
    
    init(getUserProfileUseCase: GetUserProfileUseCase) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    func fetchProfile(username: String) async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }
        
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
