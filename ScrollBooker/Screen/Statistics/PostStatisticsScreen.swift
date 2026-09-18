//
//  PostStatisticsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct PostStatisticsScreen: View {
    var viewModel: PostStatisticsViewModel
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: String(localized: "postStatistics"), onBack: onBack)
                .padding(.vertical, .s)

            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadSummary() }
                    }

                case .success(let summary):
                    ScrollView {
                        PostStatisticsSuccessView(summary: summary)
                            .padding(.base)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB.ignoresSafeArea())
        .task {
            await viewModel.loadSummary()
        }
    }
}
