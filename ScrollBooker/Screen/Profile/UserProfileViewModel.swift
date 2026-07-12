//
//  UserProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class UserProfileViewModel: HasLoadingState {
    let profileController: ProfileController
    let userId: Int
    let username: String
    
    var isLoading: Bool {
        get { profileController.isLoading }
        set { profileController.isLoading = newValue }
    }

    var errorMessage: String? {
        get { profileController.errorMessage }
        set { profileController.errorMessage = newValue }
    }
    
    init(
        userId: Int,
        username: String,
        profileController: ProfileController
    ) {
        self.userId = userId
        self.username = username
        self.profileController = profileController
    }
    
    func loadProfile() async {
        await profileController.fetchProfile(username: username)
    }
    
    func refresh() async {
        await profileController.refreshProfile(username: username)
    }
    
    // --- ACTIUNI SPECIFICE DOAR PENTRU ALTII ---
    func toggleFollow() async {
        // Logica de follow/unfollow...
    }
}
