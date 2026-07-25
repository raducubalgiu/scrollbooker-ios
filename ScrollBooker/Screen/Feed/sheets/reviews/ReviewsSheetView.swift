//
//  ReviewsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct ReviewsSheetView: View {
    let viewModel: ReviewsViewModel
    
    @State private var selectedTab: ReviewTab = .written
    @Namespace private var indicatorNS
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                    case .idle, .loading:
                        LoadingView()
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            Task { await viewModel.loadInitialData(for: selectedTab) }
                        }
                        
                    case .success(let summary):
                        ReviewsSheetSuccessView(
                            summary: summary,
                            viewModel: viewModel,
                            selectedTab: $selectedTab,
                            animationNamespace: indicatorNS
                        )
                    }
            }
            .navigationTitle("Recenzii")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadInitialData(for: selectedTab)
            }
            .onChange(of: selectedTab) { _, newTab in
                Task {
                    await viewModel.handleTabSelection(newTab)
                }
            }
        }
    }
}

