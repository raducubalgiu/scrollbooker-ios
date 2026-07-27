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
final class UserProfileViewModel {
    let profileController: ProfileController
    let userId: Int
    let username: String

    var selectedTab: ProfileTab = .posts {
        didSet {
            guard oldValue != selectedTab else { return }
            Task { await profileController.loadTabContentIfNeeded(selectedTab, userId: userId) }
        }
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
        await profileController.loadTabContentIfNeeded(selectedTab, userId: userId)
    }

    func refresh() async {
        await profileController.refresh(username: username, userId: userId, activeTab: selectedTab)
    }

    // --- ACTIUNI SPECIFICE DOAR PENTRU ALTII ---
    func toggleFollow() async {
        // Logica de follow/unfollow...
    }
}
