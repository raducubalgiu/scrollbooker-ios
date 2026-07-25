//
//  ReviewsSheetSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct ReviewsSheetSuccessView: View {
    let summary: ReviewSummary
    let viewModel: ReviewsViewModel
    
    @Binding var selectedTab: ReviewTab
    let animationNamespace: Namespace.ID
    
    var body: some View {
        if summary.ratingsCount == 0 {
            NoDataView(
                title: "Nicio recenzie",
                message: "Acest utilizator nu are încă recenzii înregistrate.",
                systemImage: "star.bubble"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ReviewsSummarySectionView(
                        summary: summary,
                        selectedRatings: viewModel.selectedRatings,
                        onRatingClick: { rating in
                            Task {
                                await viewModel.toggleRatingFilter(rating)
                            }
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 15)
                    
                    Section(header: ReviewsTabBarView(
                        selectedTab: $selectedTab,
                        animationNamespace: animationNamespace)
                    ) {
                        getTabContent(for: selectedTab)
                            .id(selectedTab)
                            .transition(.opacity)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func getTabContent(for tab: ReviewTab) -> some View {
        switch tab {
            case .written:
                WrittenReviewsTabView(viewModel: viewModel)
            case .video:
                VideoReviewsTabView(viewModel: viewModel)
        }
    }
}
