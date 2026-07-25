//
//  UnlikeReviewUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

final class UnlikeReviewUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> NoContent {
        return try await repository.unlikeReview(id: id)
    }
}
