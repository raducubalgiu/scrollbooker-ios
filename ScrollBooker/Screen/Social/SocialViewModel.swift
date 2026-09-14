//
//  SocialViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class SocialViewModel {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Social")

    private(set) var followersState: FeatureState<[UserSocial]> = .idle
    private(set) var isPagingFollowers: Bool = false
    private var followersPage = 1
    private var followersTotalCount = 0
    var hasMoreFollowers: Bool { (followersState.data?.count ?? 0) < followersTotalCount }

    private(set) var followingsState: FeatureState<[UserSocial]> = .idle
    private(set) var isPagingFollowings: Bool = false
    private var followingsPage = 1
    private var followingsTotalCount = 0
    var hasMoreFollowings: Bool { (followingsState.data?.count ?? 0) < followingsTotalCount }

    var isRefreshing: Bool = false
    var operationErrorMessage: String?

    private(set) var currentTab: SocialTab = .reviews

    private let limit = 20

    private let userId: Int
    private let getUserFollowersUseCase: GetUserFollowersUseCase
    private let getUserFollowingsUseCase: GetUserFollowingsUseCase
    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase

    init(
        userId: Int,
        getUserFollowersUseCase: GetUserFollowersUseCase,
        getUserFollowingsUseCase: GetUserFollowingsUseCase,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase
    ) {
        self.userId = userId
        self.getUserFollowersUseCase = getUserFollowersUseCase
        self.getUserFollowingsUseCase = getUserFollowingsUseCase
        self.followUserUseCase = followUserUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
    }

    func loadTabIfNeeded(tab: SocialTab) async {
        currentTab = tab
        operationErrorMessage = nil

        switch tab {
        case .reviews:
            break
        case .followers:
            guard followersState == .idle else { return }
            await loadFollowers(isFirstPage: true)
        case .following:
            guard followingsState == .idle else { return }
            await loadFollowings(isFirstPage: true)
        }
    }

    func refresh(tab: SocialTab) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        operationErrorMessage = nil

        switch tab {
        case .reviews:
            break
        case .followers:
            followersPage = 1
            await loadFollowers(isFirstPage: true)
        case .following:
            followingsPage = 1
            await loadFollowings(isFirstPage: true)
        }

        isRefreshing = false
    }

    func loadMoreFollowersIfNeeded(currentUser: UserSocial?) async {
        guard hasMoreFollowers, !isPagingFollowers, !isRefreshing else { return }
        guard let current = currentUser, current.id == followersState.data?.last?.id else { return }

        isPagingFollowers = true
        await loadFollowers(isFirstPage: false)
        isPagingFollowers = false
    }

    func loadMoreFollowingsIfNeeded(currentUser: UserSocial?) async {
        guard hasMoreFollowings, !isPagingFollowings, !isRefreshing else { return }
        guard let current = currentUser, current.id == followingsState.data?.last?.id else { return }

        isPagingFollowings = true
        await loadFollowings(isFirstPage: false)
        isPagingFollowings = false
    }

    private func loadFollowers(isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            followersState = .loading
        }

        do {
            let response = try await withLoading {
                try await getUserFollowersUseCase(userId: userId, page: followersPage, limit: limit)
            }

            let existingData = isFirstPage ? [] : (followersState.data ?? [])
            let existingIds = Set(existingData.map(\.id))
            let newData = existingData + response.results.filter { !existingIds.contains($0.id) }

            followersTotalCount = response.count
            followersPage += 1
            followersState = .success(newData)

        } catch {
            let message = logger.userMessage(for: error, context: "Loading Followers (FirstPage: \(isFirstPage))")

            if isFirstPage && (followersState.data ?? []).isEmpty {
                followersState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
    }

    private func loadFollowings(isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            followingsState = .loading
        }

        do {
            let response = try await withLoading {
                try await getUserFollowingsUseCase(userId: userId, page: followingsPage, limit: limit)
            }

            let existingData = isFirstPage ? [] : (followingsState.data ?? [])
            let existingIds = Set(existingData.map(\.id))
            let newData = existingData + response.results.filter { !existingIds.contains($0.id) }

            followingsTotalCount = response.count
            followingsPage += 1
            followingsState = .success(newData)

        } catch {
            let message = logger.userMessage(for: error, context: "Loading Followings (FirstPage: \(isFirstPage))")

            if isFirstPage && (followingsState.data ?? []).isEmpty {
                followingsState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
    }

    func toggleFollowStatus(for targetUser: UserSocial) async {
        let previousFollowersState = followersState
        let previousFollowingsState = followingsState

        let wasFollowing = targetUser.isFollow
        let newStatus = !wasFollowing

        updateUserInLists(userId: targetUser.id, isFollow: newStatus)

        do {
            if wasFollowing {
                _ = try await unfollowUserUseCase(followeeId: targetUser.id)
            } else {
                _ = try await followUserUseCase(followeeId: targetUser.id)
            }

        } catch {
            followersState = previousFollowersState
            followingsState = previousFollowingsState

            operationErrorMessage = logger.userMessage(for: error, context: "Toggling Follow Status for user \(targetUser.id)")
        }
    }

    private func updateUserInLists(userId: Int, isFollow: Bool) {
        if let currentData = followersState.data {
            let updatedData = currentData.map { user -> UserSocial in
                user.id == userId ? user.copy(isFollow: isFollow) : user
            }
            followersState = .success(updatedData)
        }

        if let currentData = followingsState.data {
            let updatedData = currentData.map { user -> UserSocial in
                user.id == userId ? user.copy(isFollow: isFollow) : user
            }
            followingsState = .success(updatedData)
        }
    }
}
