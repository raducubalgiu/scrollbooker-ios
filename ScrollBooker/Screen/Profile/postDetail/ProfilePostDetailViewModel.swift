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
@Observable
@MainActor
final class ProfilePostDetailViewModel: BaseFeedViewModel {
    private let profileController: ProfileController
    let source: ProfilePostSource
    private let userId: Int

    init(
        profileController: ProfileController,
        source: ProfilePostSource,
        userId: Int,
        startPostId: Int,
        playerManager: VideoPlayerManager,
        postInteractionStore: PostInteractionStore,
        userLocationService: UserLocationService
    ) {
        self.profileController = profileController
        self.source = source
        self.userId = userId

        let scopeKey = switch source {
        case .posts: "USER_PROFILE_DETAIL_POSTS_\(userId)"
        case .bookmarks: "USER_PROFILE_DETAIL_BOOKMARKS_\(userId)"
        }
        super.init(
            scopeKey: scopeKey,
            playerManager: playerManager,
            postInteractionStore: postInteractionStore,
            userLocationService: userLocationService
        )

        activateScope()

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

    private static func currentPosts(from controller: ProfileController, source: ProfilePostSource) -> [Post] {
        switch source {
        case .posts: return controller.postsState.data ?? []
        case .bookmarks: return controller.bookmarksState.data ?? []
        }
    }
}
