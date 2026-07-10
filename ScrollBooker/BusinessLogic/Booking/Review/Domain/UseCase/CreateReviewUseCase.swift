//
//  CreateReviewUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

final class CreateReviewUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func callAsFunction(
        id: Int,
        request: ReviewCreateRequest
    ) async throws -> Review {
        return try await repository.createReview(id: id, request: request)
    }
}
