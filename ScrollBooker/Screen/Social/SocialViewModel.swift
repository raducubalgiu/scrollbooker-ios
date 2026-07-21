//
//  SocialViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import Observation

enum SocialTabState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(data: [T], hasMore: Bool, isPaging: Bool)
    case error(String)
    
    var data: [T] {
        if case .success(let items, _, _) = self { return items }
        return []
    }
    
    var isPaging: Bool {
        if case .success(_, _, let paging) = self { return paging }
        return false
    }
}

import Foundation
import Observation

@Observable
@MainActor
final class SocialViewModel: HasLoadingState {
    private(set) var followersState: SocialTabState<UserSocial> = .idle
    private(set) var followingsState: SocialTabState<UserSocial> = .idle
    private(set) var reviewsState: SocialTabState<String> = .idle
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private(set) var currentTab: SocialTab = .reviews
    
    private var followersPage = 1
    private var followingsPage = 1
    private let limit = 20
    
    private let userId: Int
    private let getUserFollowersUseCase: GetUserFollowersUseCase
    private let getUserFollowingsUseCase: GetUserFollowingsUseCase
    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase
    
    var isLoading: Bool {
        get {
            switch currentTab {
            case .reviews:
                if case .loading = reviewsState { return true }
                return isPerformingAction
            case .followers:
                if case .loading = followersState { return true }
                return isPerformingAction
            case .following:
                if case .loading = followingsState { return true }
                return isPerformingAction
            }
        }
        set { isPerformingAction = newValue }
    }
    
    var errorMessage: String? {
        get {
            switch currentTab {
            case .reviews:
                if case .error(let msg) = reviewsState { return msg }
                return operationErrorMessage
            case .followers:
                if case .error(let msg) = followersState { return msg }
                return operationErrorMessage
            case .following:
                if case .error(let msg) = followingsState { return msg }
                return operationErrorMessage
            }
        }
        set { operationErrorMessage = newValue }
    }
    
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
        self.currentTab = tab
        operationErrorMessage = nil
        
        switch tab {
            case .reviews:
                break
                
            case .followers:
                guard followersState == .idle else { return }
                followersState = .loading
                await loadFollowers(isFirstPage: true)
                
            case .following:
                guard followingsState == .idle else { return }
                followingsState = .loading
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
        guard case .success(let currentData, let hasMore, let isPaging) = followersState,
              hasMore, !isPaging, !isRefreshing else { return }
        guard let current = currentUser, current.id == currentData.last?.id else { return }
        
        followersState = .success(data: currentData, hasMore: hasMore, isPaging: true)
        await loadFollowers(isFirstPage: false)
    }
    
    func loadMoreFollowingsIfNeeded(currentUser: UserSocial?) async {
        guard case .success(let currentData, let hasMore, let isPaging) = followingsState,
              hasMore, !isPaging, !isRefreshing else { return }
        guard let current = currentUser, current.id == currentData.last?.id else { return }
        
        followingsState = .success(data: currentData, hasMore: hasMore, isPaging: true)
        await loadFollowings(isFirstPage: false)
    }
    
    private func loadFollowers(isFirstPage: Bool) async {
        do {
            let response: PaginatedResponse<UserSocial>
            
            if isFirstPage && !isRefreshing {
                response = try await withVisibleLoading {
                    try await getUserFollowersUseCase(
                        userId: userId, page: followersPage, limit: limit
                    )
                }
            } else {
                response = try await getUserFollowersUseCase(
                    userId: userId, page: followersPage, limit: limit
                )
            }
            
            var updatedData = isFirstPage ? [] : followersState.data
            let existingIds = Set(updatedData.map(\.id))
            let unique = response.results.filter { !existingIds.contains($0.id) }
            updatedData.append(contentsOf: unique)
            
            let hasMore = updatedData.count < response.count && !response.results.isEmpty
            followersPage += 1
            
            followersState = .success(data: updatedData, hasMore: hasMore, isPaging: false)
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if isFirstPage && followersState.data.isEmpty {
                followersState = .error(message)
            } else {
                operationErrorMessage = message
                
                if case .success(let currentData, let hasMore, _) = followersState {
                    followersState = .success(data: currentData, hasMore: hasMore, isPaging: false)
                }
            }
        }
    }
    
    private func loadFollowings(isFirstPage: Bool) async {
        do {
            let response: PaginatedResponse<UserSocial>
            
            if isFirstPage && !isRefreshing {
                response = try await withVisibleLoading {
                    try await getUserFollowingsUseCase(
                        userId: userId, page: followingsPage, limit: limit
                    )
                }
            } else {
                response = try await getUserFollowingsUseCase(
                    userId: userId, page: followingsPage, limit: limit
                )
            }
            
            var updatedData = isFirstPage ? [] : followingsState.data
            let existingIds = Set(updatedData.map(\.id))
            let unique = response.results.filter { !existingIds.contains($0.id) }
            updatedData.append(contentsOf: unique)
            
            let hasMore = updatedData.count < response.count && !response.results.isEmpty
            followingsPage += 1
            
            followingsState = .success(data: updatedData, hasMore: hasMore, isPaging: false)
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if isFirstPage && followingsState.data.isEmpty {
                followingsState = .error(message)
            } else {
                operationErrorMessage = message
                if case .success(let currentData, let hasMore, _) = followingsState {
                    followingsState = .success(data: currentData, hasMore: hasMore, isPaging: false)
                }
            }
        }
    }
    
    func toggleFollowStatus(for targetUser: UserSocial) async {
        let previousFollowersState = followersState
        let previousFollowingsState = followingsState
        
        let wasFollowing = targetUser.isFollow
        let newStatus = !wasFollowing
        
        updateUserInLists(
            userId: targetUser.id,
            isFollow: newStatus
        )
        
        do {
            if wasFollowing {
                _ = try await unfollowUserUseCase(followeeId: targetUser.id)
            } else {
                _ = try await followUserUseCase(followeeId: targetUser.id)
            }
            
        } catch {
            followersState = previousFollowersState
            followingsState = previousFollowingsState
            
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
    
    private func updateUserInLists(userId: Int, isFollow: Bool) {
        if case .success(let currentData, let hasMore, let isPaging) = followersState {
            let updatedData = currentData.map { user -> UserSocial in
                if user.id == userId {
                    return user.copy(isFollow: isFollow)
                }
                return user
            }
            followersState = .success(data: updatedData, hasMore: hasMore, isPaging: isPaging)
        }
        
        if case .success(let currentData, let hasMore, let isPaging) = followingsState {
            let updatedData = currentData.map { user -> UserSocial in
                if user.id == userId {
                    return user.copy(isFollow: isFollow)
                }
                return user
            }
            followingsState = .success(data: updatedData, hasMore: hasMore, isPaging: isPaging)
        }
    }
}
