//
//  FollowingTabViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class FollowingTabViewModel: BaseFeedViewModel {
    private let getFollowingPostsUseCase: GetFollowingPostsUseCase
    private let likePostUseCase: LikePostUseCase
    private let unlikePostUseCase: UnlikePostUseCase
    private let bookmarkPostUseCase: BookmarkPostUseCase
    private let unbookmarkPostUseCase: UnbookmarkPostUseCase
    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase

    init(
        getFollowingPostsUseCase: GetFollowingPostsUseCase,
        likePostUseCase: LikePostUseCase,
        unlikePostUseCase: UnlikePostUseCase,
        bookmarkPostUseCase: BookmarkPostUseCase,
        unbookmarkPostUseCase: UnbookmarkPostUseCase,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase
    ) {
        self.getFollowingPostsUseCase = getFollowingPostsUseCase
        self.likePostUseCase = likePostUseCase
        self.unlikePostUseCase = unlikePostUseCase
        self.bookmarkPostUseCase = bookmarkPostUseCase
        self.unbookmarkPostUseCase = unbookmarkPostUseCase
        self.followUserUseCase = followUserUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
        super.init()
    }

    func initialLoad() async {
        await initialLoadIfNeeded { page, limit in
            try await self.getFollowingPostsUseCase(page: page, limit: limit)
        }
    }

    func refreshPosts() async {
        await refresh { page, limit in
            try await self.getFollowingPostsUseCase(page: page, limit: limit)
        }
    }

    func loadMore(currentPost: Post?) async {
        await loadMoreIfNeeded(currentPost: currentPost) { page, limit in
            try await self.getFollowingPostsUseCase(page: page, limit: limit)
        }
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

    func toggleFollowPost(id: Int) async {
        await toggleFollow(
            postId: id,
            followAction: { [weak self] followeeId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.followUserUseCase(followeeId: followeeId)
            },
            unfollowAction: { [weak self] followeeId in
                guard let self else { throw APIError.invalidResponse }
                return try await self.unfollowUserUseCase(followeeId: followeeId)
            }
        )
    }
}
