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

    private var rawPosts: [Post] = []
    private(set) var userCoordinates: BusinessCoordinates?
    private let userLocationService: UserLocationService
    private let postInteractionStore: PostInteractionStore

    let scopeKey: String
    private let playerManager: VideoPlayerManager

    /// `rawPosts` merged with whatever `PostInteractionStore` currently knows about each post's
    /// like/bookmark/follow state — the single source of truth every screen that might show the
    /// same post reads from, instead of each screen's own optimistic copy drifting independently.
    var posts: [Post] {
        rawPosts.map { post in
            let interaction = postInteractionStore.state(for: post.id)
            let isFollowing = postInteractionStore.isFollowing(userId: post.user.id, fallback: post.user.isFollow)

            return post.copy(
                user: post.user.copy(isFollow: isFollowing),
                counters: post.counters.copy(
                    likeCount: max(0, post.counters.likeCount + interaction.likeCountDelta),
                    bookmarkCount: max(0, post.counters.bookmarkCount + interaction.bookmarkCountDelta)
                ),
                userActions: post.userActions.copy(
                    isLiked: interaction.isLiked ?? post.userActions.isLiked,
                    isBookmarked: interaction.isBookmarked ?? post.userActions.isBookmarked
                )
            )
        }
    }

    var currentIndex: Int = 0 {
        didSet {
            updateWindow(at: currentIndex)
        }
    }

    /// Bumped every time `posts` is replaced wholesale (a fresh page-1 load, e.g. pull-to-refresh
    /// or applying Explore filters) — the View observes this to reset its own scroll position back
    /// to the top, since the old scroll offset now points at an unrelated post in the new list.
    private(set) var scrollResetTrigger: Int = 0

    var onFirstItemReady: (() -> Void)?

    private(set) var viewState: FeedPostsState = .idle
    private(set) var isPaging: Bool = false
    private(set) var isRefreshing: Bool = false

    private var page = 1
    private let limit = 10
    private var totalCount = 0

    var hasMore: Bool {
        rawPosts.count < totalCount
    }

    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return false }
        set { if newValue { viewState = .loading } }
    }

    init(
        scopeKey: String,
        playerManager: VideoPlayerManager,
        postInteractionStore: PostInteractionStore,
        userLocationService: UserLocationService
    ) {
        self.scopeKey = scopeKey
        self.playerManager = playerManager
        self.postInteractionStore = postInteractionStore
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
        guard rawPosts.isEmpty else { return }
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
              current.id == rawPosts.last?.id
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
                rawPosts = response.results
                currentIndex = 0
                scrollResetTrigger += 1
            } else {
                let existingIds = Set(rawPosts.map(\.id))
                let unique = response.results.filter { !existingIds.contains($0.id) }
                rawPosts.append(contentsOf: unique)
            }

            totalCount = response.count
            page += 1

            if rawPosts.isEmpty {
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

    func toggleLikePost(id: Int) async {
        guard let post = posts.first(where: { $0.id == id }) else { return }
        await postInteractionStore.toggleLike(postId: id, currentlyLiked: post.userActions.isLiked)
    }

    func toggleBookmarkPost(id: Int) async {
        guard let post = posts.first(where: { $0.id == id }) else { return }
        await postInteractionStore.toggleBookmark(postId: id, currentlyBookmarked: post.userActions.isBookmarked)
    }

    func toggleFollowPost(id: Int) async {
        guard let post = posts.first(where: { $0.id == id }) else { return }
        await postInteractionStore.toggleFollow(userId: post.user.id, currentlyFollowing: post.user.isFollow)
    }

    func sharePost(id: Int, channel: ShareChannelEnum) async {
        await postInteractionStore.sharePost(postId: id, channel: channel)
    }

    /// Lets a subclass whose `posts` come from an already-loaded, externally-owned source
    /// (e.g. `ProfileController.postsState`/`.bookmarksState`, for the profile post-detail
    /// screen) push a fresh snapshot in, instead of self-paginating via `load(fetchBlock:)`.
    func syncExternalPosts(_ newPosts: [Post]) {
        rawPosts = newPosts
        viewState = rawPosts.isEmpty ? .empty : .success(posts)
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

    func togglePlayer(postId: Int) {
        playerManager.togglePlayer(scopeKey: scopeKey, postId: postId)
    }

    func isPaused(postId: Int) -> Bool {
        playerManager.isPaused(scopeKey: scopeKey, postId: postId)
    }

    func player(for postId: Int) -> AVPlayer? {
        playerManager.existingPlayer(scopeKey: scopeKey, postId: postId)
    }

    func isPlayerReady(for postId: Int) -> Bool {
        playerManager.isReady(scopeKey: scopeKey, postId: postId)
    }
}
