//
//  VideoReviewsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct VideoReviewsTabView: View {
    let viewModel: ReviewsViewModel
    var onNavigateToVideoReview: (Post) -> Void = { _ in }

    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        Group {
            if viewModel.isSaving {
                LoadingView()
                    .frame(height: 300)
            } else if viewModel.videoReviews.isEmpty {
                NoDataView(
                    title: String(localized: "reviews"),
                    message: String(localized: "message_empty_video_reviews"),
                    systemImage: "video.slash"
                )
                .padding(.top, 40)
            } else {
                VStack(spacing: 0) {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(viewModel.videoReviews, id: \.id) { post in
                            PostGridView(
                                postId: post.id,
                                mediaFiles: post.mediaFiles,
                                viewsCount: post.counters.viewsCount,
                                rating: post.review?.rating,
                                onNavigateToPost: { _ in onNavigateToVideoReview(post) }
                            )
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreVideoReviews(currentPost: post)
                                }
                            }
                        }
                    }
                    
                    if viewModel.isPaging && viewModel.canLoadMoreVideo {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .frame(minHeight: 50)
                    }
                }
            }
        }
    }
}
