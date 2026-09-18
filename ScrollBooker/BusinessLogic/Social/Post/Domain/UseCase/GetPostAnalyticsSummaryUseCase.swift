//
//  GetPostAnalyticsSummaryUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class GetPostAnalyticsSummaryUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(postId: Int) async throws -> PostAnalyticsSummary {
        try await repository.getPostAnalyticsSummary(postId: postId)
    }
}
