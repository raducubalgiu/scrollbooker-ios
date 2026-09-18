//
//  GetVideoReviewsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

final class GetVideoReviewsUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(
        businessId: Int,
        employeeId: Int?,
        ratings: [Int]?,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Post> {

        try await repository.getVideoReviews(
            businessId: businessId,
            employeeId: employeeId,
            ratings: ratings,
            page: page,
            limit: limit
        )
    }
}
