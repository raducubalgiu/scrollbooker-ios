//
//  UpdateReviewUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

final class UpdateReviewUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func callAsFunction(
        id: Int,
        request: ReviewUpdateRequest
    ) async throws -> Review {
        return try await repository.updateReview(id: id, request: request)
    }
}
