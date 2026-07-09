//
//  SocialViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class SocialViewModel: HasLoadingState {
    var reviewsUiState = UiState(data: [Review]())
    var followersUiState = UiState(data: [UserSocial]())
    var followingsUiState = UiState(data: [UserSocial]())
    
    private let userId: Int
    private let getUserFollowers: GetUserFollowersUseCase
    private let getUserFollowings: GetUserFollowingsUseCase
    
    private var followersPage = 1
    private var followersTotalCount = 0
    private var isFollowersPaging = false
    
    private var followingsPage = 1
    private var followingsTotalCount = 0
    private var isFollowingsPaging = false
    
    private let limit = 20
    
    var followersCount: Int { followersTotalCount }
    var followingsCount: Int { followingsTotalCount }
    
    var hasMoreFollowers: Bool { followersUiState.data.count < followersTotalCount }
    var hasMoreFollowings: Bool { followingsUiState.data.count < followingsTotalCount }
    
    private var currentTab: SocialTab = .reviews
    
    var isLoading: Bool {
        get {
            switch currentTab {
            case .reviews: return reviewsUiState.isLoading
            case .followers: return followersUiState.isLoading
            case .following: return followingsUiState.isLoading
            }
        }
        set {
            switch currentTab {
            case .reviews: reviewsUiState.isLoading = newValue
            case .followers: followersUiState.isLoading = newValue
            case .following: followingsUiState.isLoading = newValue
            }
        }
    }
    
    var errorMessage: String? {
        get {
            switch currentTab {
            case .reviews: return reviewsUiState.errorMessage
            case .followers: return followersUiState.errorMessage
            case .following: return followingsUiState.errorMessage
            }
        }
        set {
            switch currentTab {
            case .reviews: reviewsUiState.errorMessage = newValue
            case .followers: followersUiState.errorMessage = newValue
            case .following: followingsUiState.errorMessage = newValue
            }
        }
    }
    
    init(
        userId: Int,
        getUserFollowers: GetUserFollowersUseCase,
        getUserFollowings: GetUserFollowingsUseCase
    ) {
        self.userId = userId
        self.getUserFollowers = getUserFollowers
        self.getUserFollowings = getUserFollowings
    }
    
    func loadTabIfNeeded(tab: SocialTab) async {
        self.currentTab = tab
        
        switch tab {
        case .reviews:
            // Logica de încărcare pentru recenzii când va fi disponibilă
            break
            
        case .followers:
            guard followersUiState.data.isEmpty else { return }
            await loadFollowers(isFirstPage: true)
            
        case .following:
            guard followingsUiState.data.isEmpty else { return }
            await loadFollowings(isFirstPage: true)
        }
    }
    
    func refresh(tab: SocialTab) async {
        switch tab {
        case .reviews:
            break
        case .followers:
            guard !followersUiState.isRefreshing else { return }
            followersUiState.isRefreshing = true
            followersPage = 1
            await loadFollowers(isFirstPage: true)
            followersUiState.isRefreshing = false
            
        case .following:
            guard !followingsUiState.isRefreshing else { return }
            followingsUiState.isRefreshing = true
            followingsPage = 1
            await loadFollowings(isFirstPage: true)
            followingsUiState.isRefreshing = false
        }
    }
    
    func loadMoreFollowersIfNeeded(currentUser: UserSocial?) async {
        guard hasMoreFollowers, !followersUiState.isLoading, !followersUiState.isRefreshing, !isFollowersPaging else { return }
        guard let current = currentUser, current.id == followersUiState.data.last?.id else { return }
        
        isFollowersPaging = true
        await loadFollowers(isFirstPage: false)
        isFollowersPaging = false
    }
    
    func loadMoreFollowingsIfNeeded(currentUser: UserSocial?) async {
        guard hasMoreFollowings, !followingsUiState.isLoading, !followingsUiState.isRefreshing, !isFollowingsPaging else { return }
        guard let current = currentUser, current.id == followingsUiState.data.last?.id else { return }
        
        isFollowingsPaging = true
        await loadFollowings(isFirstPage: false)
        isFollowingsPaging = false
    }
    
    private func loadFollowers(isFirstPage: Bool) async {
        if isFirstPage { followersUiState.errorMessage = nil }
        
        do {
            let response: PaginatedResponse<UserSocial>
            
            if isFirstPage {
                response = try await withVisibleLoading {
                    try await getUserFollowers(userId: userId, page: followersPage, limit: limit)
                }
            } else {
                response = try await getUserFollowers(userId: userId, page: followersPage, limit: limit)
            }
            
            if isFirstPage {
                followersUiState.data = response.results
            } else {
                let existingIds = Set(followersUiState.data.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                followersUiState.data.append(contentsOf: unique)
            }
            
            followersTotalCount = response.count
            followersPage += 1
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if isFirstPage { followersUiState.errorMessage = message }
        }
    }
    
    private func loadFollowings(isFirstPage: Bool) async {
        if isFirstPage { followingsUiState.errorMessage = nil }
        
        do {
            let response: PaginatedResponse<UserSocial>
            
            if isFirstPage {
                response = try await withVisibleLoading {
                    try await getUserFollowings(userId: userId, page: followingsPage, limit: limit)
                }
            } else {
                response = try await getUserFollowings(userId: userId, page: followingsPage, limit: limit)
            }
            
            if isFirstPage {
                followingsUiState.data = response.results
            } else {
                let existingIds = Set(followingsUiState.data.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                followingsUiState.data.append(contentsOf: unique)
            }
            
            followingsTotalCount = response.count
            followingsPage += 1
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if isFirstPage { followingsUiState.errorMessage = message }
        }
    }
}
