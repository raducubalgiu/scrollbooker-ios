//
//  ProfilePostDetailViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation
import Observation

/// TikTok-style full-screen pager for a post tapped inside a profile's Posts/Bookmarks grid.
/// Reuses `BaseFeedViewModel`'s existing player-window/like/bookmark logic (the same one
/// ExploreTab/FollowingTab use), but never self-paginates — it mirrors whatever `ProfileController`
/// already holds (the exact list + pagination cursor the grid itself used) via `syncExternalPosts`,
/// so opening the detail screen doesn't trigger a second, redundant fetch of the same data.
///
/// Deliberately simple for now: each instance owns its own `AVPlayer`s privately, released via
/// ARC once the router's session slot is cleared. A future shared `PlayerManager` singleton will
/// replace this (and ExploreTab/FollowingTab's own player handling) — not built here yet.
@Observable
@MainActor
final class ProfilePostDetailViewModel: BaseFeedViewModel {
    private let profileController: ProfileController
    let source: ProfilePostSource
    private let userId: Int

    private let likePostUseCase: LikePostUseCase
    private let unlikePostUseCase: UnlikePostUseCase
    private let bookmarkPostUseCase: BookmarkPostUseCase
    private let unbookmarkPostUseCase: UnbookmarkPostUseCase

    init(
        profileController: ProfileController,
        source: ProfilePostSource,
        userId: Int,
        startPostId: Int,
        likePostUseCase: LikePostUseCase,
        unlikePostUseCase: UnlikePostUseCase,
        bookmarkPostUseCase: BookmarkPostUseCase,
        unbookmarkPostUseCase: UnbookmarkPostUseCase
    ) {
        self.profileController = profileController
        self.source = source
        self.userId = userId
        self.likePostUseCase = likePostUseCase
        self.unlikePostUseCase = unlikePostUseCase
        self.bookmarkPostUseCase = bookmarkPostUseCase
        self.unbookmarkPostUseCase = unbookmarkPostUseCase
        super.init()

        let initialPosts = Self.currentPosts(from: profileController, source: source)
        syncExternalPosts(initialPosts)

        if let startIndex = initialPosts.firstIndex(where: { $0.id == startPostId }) {
            currentIndex = startIndex
        }
    }

    func loadMore(currentPost: Post?) async {
        switch source {
        case .posts:
            await profileController.loadMorePostsIfNeeded(userId: userId, currentPost: currentPost)
        case .bookmarks:
            await profileController.loadMoreBookmarksIfNeeded(userId: userId, currentPost: currentPost)
        }

        syncExternalPosts(Self.currentPosts(from: profileController, source: source))
    }

    func toggleLikePost(id: Int) async {
        await toggleLike(
            postId: id,
            likeAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.likePostUseCase(id: postId)
            },
            unlikeAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.unlikePostUseCase(id: postId)
            }
        )
    }

    func toggleBookmarkPost(id: Int) async {
        await toggleBookmark(
            postId: id,
            bookmarkAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.bookmarkPostUseCase(id: postId)
            },
            unbookmarkAction: { [weak self] postId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.unbookmarkPostUseCase(id: postId)
            }
        )
    }

    private static func currentPosts(from controller: ProfileController, source: ProfilePostSource) -> [Post] {
        switch source {
        case .posts: return controller.postsState.data ?? []
        case .bookmarks: return controller.bookmarksState.data ?? []
        }
    }
}
