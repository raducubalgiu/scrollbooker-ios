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

    init(
        reviewsViewModel: ReviewsViewModel,
        startPostId: Int,
        playerManager: VideoPlayerManager,
        postInteractionStore: PostInteractionStore,
        userLocationService: UserLocationService
    ) {
        self.reviewsViewModel = reviewsViewModel
        super.init(
            scopeKey: "review_detail_\(startPostId)",
            playerManager: playerManager,
            postInteractionStore: postInteractionStore,
            userLocationService: userLocationService
        )

        activateScope()

        syncExternalPosts(reviewsViewModel.videoReviews)

        if let startIndex = reviewsViewModel.videoReviews.firstIndex(where: { $0.id == startPostId }) {
            currentIndex = startIndex
        }
    }

    func loadMore(currentPost: Post?) async {
        await reviewsViewModel.loadMoreVideoReviews(currentPost: currentPost)
        syncExternalPosts(reviewsViewModel.videoReviews)
    }
}
