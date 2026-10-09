//
//  BaseFeedViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Observation
import AVKit
import Foundation
import OSLog

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

enum FeedPostsState {
    case idle
    case loading
    case empty
    case success([Post])
    case error(String)
}

@Observable
@MainActor
class BaseFeedViewModel {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Feed")

    private(set) var posts: [Post] = []
    private(set) var userCoordinates: BusinessCoordinates?
    private let userLocationService: UserLocationService

    let scopeKey: String
    private let playerManager: VideoPlayerManager

    var currentIndex: Int = 0 {
        didSet {
            updateWindow(at: currentIndex)
        }
    }

    var onFirstItemReady: (() -> Void)?

    private(set) var viewState: FeedPostsState = .idle
    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false

    private var page = 1
    private let limit = 10
    private var totalCount = 0
    
    var operationErrorMessage: String? = nil

    var hasMore: Bool {
        posts.count < totalCount
    }

    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return false }
        set { if newValue { viewState = .loading } }
    }

    init(scopeKey: String, playerManager: VideoPlayerManager, userLocationService: UserLocationService) {
        self.scopeKey = scopeKey
        self.playerManager = playerManager
        self.userLocationService = userLocationService
        Task { @MainActor [weak self] in
            self?.userCoordinates = await self?.userLocationService.currentLocation()
        }
    }

    deinit {
        let manager = playerManager
        let key = scopeKey
        Task { @MainActor in
            manager.releaseScope(key)
        }
    }

    func initialLoadIfNeeded(fetchBlock: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Post>) async {
        guard posts.isEmpty else { return }
        await load(isFirstPage: true, fetchBlock: fetchBlock)
    }

    func refresh(fetchBlock: (_ page: Int, _ limit: Int) async throws -> PaginatedResponse<Post>) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        page = 1
        await load(isFirstPage: true, fetchBlock: fetchBlock)
        isRefreshing = false
    }

    func loadMoreIfNeeded(
        currentPost: Post?,
        fetchBlock: (_ page: Int, _ limit: Int
    ) async throws -> PaginatedResponse<Post>) async {
        guard hasMore, !isPaging, !isRefreshing, !isLoading else { return }
        
        guard let current = currentPost,
              current.id == posts.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false, fetchBlock: fetchBlock)
        isPaging = false
    }

    private func load(
        isFirstPage: Bool,
        fetchBlock: (_ page: Int, _ limit: Int
    ) async throws -> PaginatedResponse<Post>) async {
        
        if isFirstPage && !isRefreshing {
            viewState = .loading
        }

        do {
            let response = try await fetchBlock(page, limit)

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
                viewState = .empty
            } else {
                viewState = .success(posts)
            }

        } catch {
            let message = logger.userMessage(for: error, context: "Loading Feed (FirstPage: \(isFirstPage))")

            if isFirstPage {
                viewState = .error(message)
            }
        }
    }
    
    func toggleLike(
        postId: Int,
        likeAction: (Int) async throws -> NoContent,
        unlikeAction: (Int) async throws -> NoContent
    ) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        let originalPost = posts[index]
        let currentlyLiked = originalPost.userActions.isLiked
        
        let newIsLiked = !currentlyLiked
        let newLikeCount = currentlyLiked ? max(0, originalPost.counters.likeCount - 1) : originalPost.counters.likeCount + 1
        
        posts[index] = originalPost.copy(
            counters: originalPost.counters.copy(likeCount: newLikeCount),
            userActions: originalPost.userActions.copy(isLiked: newIsLiked)
        )
        
        operationErrorMessage = nil
        
        do {
            if currentlyLiked {
                _ = try await unlikeAction(postId)
            } else {
                _ = try await likeAction(postId)
            }
        } catch {
            if let currentIndex = posts.firstIndex(where: { $0.id == postId }) {
                posts[currentIndex] = originalPost
            }
            operationErrorMessage = logger.userMessage(for: error, context: "Toggling Like for post \(postId)")
        }
    }

    func toggleBookmark(
        postId: Int,
        bookmarkAction: (Int) async throws -> NoContent,
        unbookmarkAction: (Int) async throws -> NoContent
    ) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        let originalPost = posts[index]
        let currentlyBookmarked = originalPost.userActions.isBookmarked
        
        let newIsBookmarked = !currentlyBookmarked
        
        posts[index] = originalPost.copy(
            userActions: originalPost.userActions.copy(isBookmarked: newIsBookmarked)
        )
        
        operationErrorMessage = nil
        
        do {
            if currentlyBookmarked {
                _ = try await unbookmarkAction(postId)
            } else {
                _ = try await bookmarkAction(postId)
            }
        } catch {
            if let currentIndex = posts.firstIndex(where: { $0.id == postId }) {
                posts[currentIndex] = originalPost
            }
            operationErrorMessage = logger.userMessage(for: error, context: "Toggling Bookmark for post \(postId)")
        }
    }
    
    func sharePostBase(
        postId: Int,
        channel: ShareChannelEnum,
        shareAction: (Int, ShareChannelEnum) async throws -> NoContent
    ) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        let originalPost = posts[index]
        let newShareCount = originalPost.counters.shareCount + 1
        
        posts[index] = originalPost.copy(
            counters: originalPost.counters.copy(shareCount: newShareCount)
        )
        
        operationErrorMessage = nil
        
        do {
            _ = try await shareAction(postId, channel)
        } catch {
            if let currentIndex = posts.firstIndex(where: { $0.id == postId }) {
                posts[currentIndex] = originalPost
            }
            operationErrorMessage = logger.userMessage(for: error, context: "Sharing post \(postId) on channel \(channel.rawValue)")
        }
    }

    
    func toggleFollow(
        postId: Int,
        followAction: (Int) async throws -> NoContent,
        unfollowAction: (Int) async throws -> NoContent
    ) async {
        guard let originalPost = posts.first(where: { $0.id == postId }) else { return }

        let followeeId = originalPost.user.id
        let currentlyFollowing = originalPost.user.isFollow
        let newIsFollow = !currentlyFollowing

        let affectedIndices = posts.indices.filter { posts[$0].user.id == followeeId }
        let originalPostsByIndex = Dictionary(uniqueKeysWithValues: affectedIndices.map { ($0, posts[$0]) })

        for index in affectedIndices {
            posts[index] = posts[index].copy(user: posts[index].user.copy(isFollow: newIsFollow))
        }

        operationErrorMessage = nil

        do {
            if currentlyFollowing {
                _ = try await unfollowAction(followeeId)
            } else {
                _ = try await followAction(followeeId)
            }
        } catch {
            for (index, originalPost) in originalPostsByIndex {
                posts[index] = originalPost
            }
            operationErrorMessage = logger.userMessage(for: error, context: "Toggling Follow for user \(followeeId)")
        }
    }
    
    

    /// Lets a subclass whose `posts` come from an already-loaded, externally-owned source
    /// (e.g. `ProfileController.postsState`/`.bookmarksState`, for the profile post-detail
    /// screen) push a fresh snapshot in, instead of self-paginating via `load(fetchBlock:)`.
    func syncExternalPosts(_ newPosts: [Post]) {
        posts = newPosts
        viewState = posts.isEmpty ? .empty : .success(posts)
    }

    func updateWindow(at index: Int) {
        playerManager.ensureWindow(
            scopeKey: scopeKey,
            posts: posts,
            centerIndex: index,
            onFirstReady: onFirstItemReady
        )
    }

    func playCurrent() {
        guard let currentPostId = posts[safe: currentIndex]?.id else { return }
        playerManager.playCurrent(scopeKey: scopeKey, postId: currentPostId)
    }

    func pauseAll() {
        playerManager.pauseAll(scopeKey: scopeKey)
    }

    func activateScope() {
        playerManager.activateScope(scopeKey)
    }

    func player(for postId: Int) -> AVPlayer? {
        playerManager.existingPlayer(scopeKey: scopeKey, postId: postId)
    }

    func isPlayerReady(for postId: Int) -> Bool {
        playerManager.isReady(scopeKey: scopeKey, postId: postId)
    }
}
