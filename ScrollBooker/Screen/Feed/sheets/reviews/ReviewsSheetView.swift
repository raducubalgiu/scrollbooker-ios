//
//  ReviewsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct ReviewsSheetView: View {
    let viewModel: ReviewsViewModel
    @Namespace private var indicatorNS
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadInitialData() }
                    }
                    
                case .success(let summary):
                    @Bindable var bindableViewModel = viewModel
                    
                    ReviewsSheetSuccessView(
                        summary: summary,
                        viewModel: viewModel,
                        selectedTab: $bindableViewModel.selectedTab,
                        animationNamespace: indicatorNS
                    )
                }
            }
            .navigationTitle("Recenzii")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
}

