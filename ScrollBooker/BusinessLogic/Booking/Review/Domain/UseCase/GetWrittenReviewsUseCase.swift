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
        businessId: Int, employeeId: Int?, page: Int, limit: Int, ratings: [Int]?
    ) async throws -> PaginatedResponse<Review> {

        try await repository.getWrittenReviews(
            businessId: businessId,
            employeeId: employeeId,
            page: page,
            limit: limit,
            ratings: ratings
        )
    }
}
