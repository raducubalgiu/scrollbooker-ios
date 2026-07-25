//
//  GetWrittenReviewsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//


final class GetWrittenReviewsUseCase {
    private let repository: ReviewRepository

    init(repository: ReviewRepository) {
        self.repository = repository
    }

    func callAsFunction(
        userId: Int, page: Int, limit: Int, ratings: [Int]?
    ) async throws -> PaginatedResponse<Review> {

        try await repository.getWrittenReviews(
            userId: userId,
            page: page,
            limit: limit,
            ratings: ratings
        )
    }
}
