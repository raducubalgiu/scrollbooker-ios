//
//  UserProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class UserProfileViewModel {
    let profileController: ProfileController
    let userId: Int
    let username: String

    private(set) var isSavingFollow = false

    var selectedTab: ProfileTab = .posts {
        didSet {
            guard oldValue != selectedTab else { return }
            Task { await profileController.loadTabContentIfNeeded(selectedTab, userId: userId) }
        }
    }

    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "UserProfile")

    init(
        userId: Int,
        username: String,
        profileController: ProfileController,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase
    ) {
        self.userId = userId
        self.username = username
        self.profileController = profileController
        self.followUserUseCase = followUserUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
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
        guard !isSavingFollow else { return }
        guard let profile = profileController.profile else { return }

        isSavingFollow = true
        defer { isSavingFollow = false }

        let wasFollowing = profile.isFollow
        let newFollowersCount = max(0, profile.counters.followersCount + (wasFollowing ? -1 : 1))

        profileController.updateProfile(
            profile.copy(
                isFollow: !wasFollowing,
                counters: profile.counters.copy(followersCount: newFollowersCount)
            )
        )

        do {
            if wasFollowing {
                _ = try await unfollowUserUseCase(followeeId: userId)
            } else {
                _ = try await followUserUseCase(followeeId: userId)
            }
        } catch {
            profileController.updateProfile(profile)
            logger.error("ERROR: on Toggling Follow for user \(self.userId): \(error.localizedDescription)")
        }
    }
}
