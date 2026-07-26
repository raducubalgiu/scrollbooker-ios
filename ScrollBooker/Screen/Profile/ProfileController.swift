//
//  ProfileController.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation
import Observation

enum UserPostsState {
    case idle
    case loading
    case empty
    case success([Post])
    case error(String)
}

@Observable
@MainActor
final class ProfileController: HasLoadingState {
    var uiState = UiState(data: UserProfile?.none)
    private(set) var viewState: ProfileState = .idle
    
    // --- STARE POSTĂRI (Adăugată aici) ---
    private(set) var posts: [Post] = []
    private(set) var postsViewState: FeedPostsState = .idle
    private(set) var isPaging: Bool = false
    
    private var page = 1
    private let limit = 10
    private var totalCount = 0
    
    var hasMore: Bool {
        posts.count < totalCount
    }
    
    var isLoading: Bool {
        get {
            if case .loading = viewState { return true }
            if case .loading = postsViewState { return true }
            return uiState.isLoading
        }
        set {
            uiState.isLoading = newValue
        }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            if case .error(let msg) = postsViewState { return msg }
            return uiState.errorMessage
        }
        set {
            uiState.errorMessage = newValue
        }
    }
    
    private let getUserProfileUseCase: GetUserProfileUseCase
    private let getUserPostsUseCase: GetUserPostsUseCase
    private let getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase
    
    init(
        getUserProfileUseCase: GetUserProfileUseCase,
        getUserPostsUseCase: GetUserPostsUseCase,
        getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.getUserPostsUseCase = getUserPostsUseCase
        self.getUserBookmarkedPostsUseCase = getUserBookmarkedPostsUseCase
    }
    
    // Fetch Profile
    func fetchProfile(username: String, hasMinLoading: Bool = false) async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }
        
        if hasMinLoading {
            await withVisibleLoading {
                await performFetch(username: username)
            }
        } else {
            await performFetch(username: username)
        }
    }
    
    private func performFetch(username: String) async {
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
    
    // Fetch Posts
    func loadInitialPosts(userId: Int) async {
        guard posts.isEmpty else { return }
        await loadPostsData(userId: userId, isFirstPage: true)
    }
    
    func refreshPosts(userId: Int) async {
        page = 1
        await loadPostsData(userId: userId, isFirstPage: true)
    }
    
    func loadMorePostsIfNeeded(userId: Int, currentPost: Post?) async {
        guard hasMore, !isPaging, !isLoading else { return }
        guard let current = currentPost, current.id == posts.last?.id else { return }
        
        isPaging = true
        await loadPostsData(userId: userId, isFirstPage: false)
        isPaging = false
    }
    
    private func loadPostsData(userId: Int, isFirstPage: Bool) async {
        if isFirstPage && !uiState.isRefreshing {
            postsViewState = .loading
        }
        
        do {
            let response = try await getUserPostsUseCase(userId: userId, page: page, limit: limit)
            
            if isFirstPage {
                posts = response.results
            } else {
                let existingIds = Set(posts.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                posts.append(contentsOf: unique)
            }
            
            totalCount = response.count
            page += 1
            
            if posts.isEmpty {
                postsViewState = .empty
            } else {
                postsViewState = .success(posts)
            }
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            
            if isFirstPage {
                postsViewState = .error(message)
            } else {
                print("Eroare paginare profil: \(message)")
            }
        }
    }
}
