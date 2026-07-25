//
//  WrittenReviewsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct WrittenReviewsTabView: View {
    let viewModel: ReviewsViewModel
    
    var body: some View {
        Group {
            if viewModel.writtenReviews.isEmpty && !viewModel.isPerformingAction {
                NoDataView(
                    title: "Fără recenzii text",
                    message: "Nu s-au găsit recenzii scrise pentru criteriile selectate.",
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
                               
                            }
                        )
                        
                        Divider()
                            .padding(.horizontal, 16)
                    }
                    
                    if viewModel.canLoadMoreWritten {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreWrittenReviews()
                                }
                            }
                    }
                }
            }
        }
    }
}
            
    

