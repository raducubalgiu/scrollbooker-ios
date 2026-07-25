//
//  GetReviewSummaryUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

final class GetReviewSummaryUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int) async throws -> ReviewSummary {
        try await repository.getReviewSummary(userId: userId)
    }
}
