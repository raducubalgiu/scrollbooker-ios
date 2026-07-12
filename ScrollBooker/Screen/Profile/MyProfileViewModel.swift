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
final class MyProfileViewModel: HasLoadingState {
    let profileController: ProfileController
    private let session: SessionManager
    
    var isLoading: Bool {
        get { if case .loading = profileController.viewState { return true }; return profileController.uiState.isLoading }
        set { profileController.uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { if case .error(let msg) = profileController.viewState { return msg }; return profileController.uiState.errorMessage }
        set { profileController.uiState.errorMessage = newValue }
    }
    
    init(session: SessionManager, profileController: ProfileController) {
        self.session = session
        self.profileController = profileController
    }
    
    func loadProfile() async {
        guard let username = session.userInfo?.username else {
            profileController.uiState.errorMessage = "Username not found"
            return
        }
        await profileController.fetchProfile(username: username)
    }
    
    func refresh() async {
        guard let username = session.userInfo?.username else { return }
        await profileController.refreshProfile(username: username)
    }
    
    func updateBio(newBio: String) async {
        // Logica de editare bio...
    }
}
