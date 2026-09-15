//
//  VideoReviewsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct VideoReviewsTabView: View {
    let viewModel: ReviewsViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        Group {
            if viewModel.videoReviews.isEmpty && !viewModel.isSaving {
                NoDataView(
                    title: String(localized: "notFoundVideoReviews"),
                    message: String(localized: "notFoundVideoReviewsDescription"),
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
                                onNavigateToPost: { postId in }
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
