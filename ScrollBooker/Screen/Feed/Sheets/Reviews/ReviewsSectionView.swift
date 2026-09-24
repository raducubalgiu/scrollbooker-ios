//
//  ReviewsSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

struct ReviewsSectionView: View {
    @Bindable var viewModel: ReviewsViewModel
    var onNavigateToVideoReview: (Post) -> Void = { _ in }
    @Namespace private var indicatorNS

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .idle, .loading:
                LoadingView()
            case .error:
                ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                    Task { await viewModel.loadInitialData() }
                }
            case .success(let summary):
                ReviewsSheetSuccessView(
                    summary: summary,
                    viewModel: viewModel,
                    selectedTab: $viewModel.selectedTab,
                    animationNamespace: indicatorNS,
                    onNavigateToVideoReview: onNavigateToVideoReview
                )
            }
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}
