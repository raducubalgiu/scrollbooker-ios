//
//  ReviewVideoDetailViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ReviewVideoDetailViewModel: BaseFeedViewModel {
    private let reviewsViewModel: ReviewsViewModel

    private let likePostUseCase: LikePostUseCase
    private let unlikePostUseCase: UnlikePostUseCase
    private let bookmarkPostUseCase: BookmarkPostUseCase
    private let unbookmarkPostUseCase: UnbookmarkPostUseCase
    private let followUserUseCase: FollowUserUseCase
    private let unfollowUserUseCase: UnfollowUserUseCase
    private let sharePostUseCase: SharePostUseCase

    init(
        reviewsViewModel: ReviewsViewModel,
        startPostId: Int,
        likePostUseCase: LikePostUseCase,
        unlikePostUseCase: UnlikePostUseCase,
        bookmarkPostUseCase: BookmarkPostUseCase,
        unbookmarkPostUseCase: UnbookmarkPostUseCase,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase,
        sharePostUseCase: SharePostUseCase
    ) {
        self.reviewsViewModel = reviewsViewModel
        self.likePostUseCase = likePostUseCase
        self.unlikePostUseCase = unlikePostUseCase
        self.bookmarkPostUseCase = bookmarkPostUseCase
        self.unbookmarkPostUseCase = unbookmarkPostUseCase
        self.followUserUseCase = followUserUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
        self.sharePostUseCase = sharePostUseCase
        super.init()

        syncExternalPosts(reviewsViewModel.videoReviews)

        if let startIndex = reviewsViewModel.videoReviews.firstIndex(where: { $0.id == startPostId }) {
            currentIndex = startIndex
        }
    }

    func loadMore(currentPost: Post?) async {
        await reviewsViewModel.loadMoreVideoReviews(currentPost: currentPost)
        syncExternalPosts(reviewsViewModel.videoReviews)
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

    func sharePost(id: Int, channel: ShareChannelEnum) async {
        await sharePostBase(
            postId: id,
            channel: channel,
            shareAction: { [weak self] postId, selectedChannel in
                guard let self else { throw APIError.invalidResponse }
                return try await self.sharePostUseCase(id: postId, channel: selectedChannel)
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
