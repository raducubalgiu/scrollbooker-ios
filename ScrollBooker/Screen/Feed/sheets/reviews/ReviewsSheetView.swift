//
//  ReviewsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct ReviewsSheetView: View {
    @Bindable var viewModel: ReviewsViewModel
    @Namespace private var indicatorNS
    
    var body: some View {
        @Bindable var bindableViewModel = viewModel
        
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
                        Task { await viewModel.loadInitialData() }
                    }
                    
                case .success(let summary):
                    ReviewsSheetSuccessView(
                        summary: summary,
                        viewModel: viewModel,
                        selectedTab: $bindableViewModel.selectedTab,
                        animationNamespace: indicatorNS
                    )
                }
            }
            .navigationTitle(String(localized: "reviews"))
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
}

