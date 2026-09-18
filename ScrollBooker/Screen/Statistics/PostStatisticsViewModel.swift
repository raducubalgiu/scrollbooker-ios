//
//  PostStatisticsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class PostStatisticsViewModel {
    private(set) var viewState: FeatureState<PostAnalyticsSummary> = .idle

    private let postId: Int
    private let getPostAnalyticsSummaryUseCase: GetPostAnalyticsSummaryUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "PostStatistics")

    init(postId: Int, getPostAnalyticsSummaryUseCase: GetPostAnalyticsSummaryUseCase) {
        self.postId = postId
        self.getPostAnalyticsSummaryUseCase = getPostAnalyticsSummaryUseCase
    }

    func loadSummary() async {
        viewState = .loading

        do {
            let summary = try await withLoading {
                try await getPostAnalyticsSummaryUseCase(postId: postId)
            }
            viewState = .success(summary)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Post Analytics Summary"))
        }
    }
}
