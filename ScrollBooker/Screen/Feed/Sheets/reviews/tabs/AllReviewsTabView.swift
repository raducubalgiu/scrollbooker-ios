//
//  AllReviewsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct AllReviewsTabView: View {
    let viewModel: ReviewsViewModel

    var body: some View {
        Group {
            if viewModel.isSaving {
                LoadingView()
                    .frame(height: 300)
            } else if viewModel.writtenReviews.isEmpty {
                NoDataView(
                    title: String(localized: "reviews"),
                    message: String(localized: "message_empty_results"),
                    systemImage: "doc.text.magnifyingglass"
                )
                .padding(.top, 40)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.writtenReviews, id: \.id) { review in
                        let uiState = ReviewActionUiState(
                            likeCount: review.likeCount,
                            isLiked: review.isLiked,
                            isLikedByProductOwner: review.isLikedByProductOwner
                        )

                        WrittenReviewCard(
                            review: review,
                            reviewUi: uiState,
                            onNavigateToReviewDetail: {},
                            onLike: {
                                Task {
                                    await viewModel.toggleLikeWrittenReview(id: review.id)
                                }
                            }
                        )
                        .onAppear {
                            Task {
                                await viewModel.loadMoreWrittenReviews(currentReview: review)
                            }
                        }

                        Divider().padding(.horizontal, 16)
                    }

                    if viewModel.isPaging && viewModel.canLoadMoreWritten {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}
