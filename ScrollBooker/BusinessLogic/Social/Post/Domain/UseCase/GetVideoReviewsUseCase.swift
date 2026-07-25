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
        userId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Post> {

        try await repository.getVideoReviews(
            userId: userId,
            page: page,
            limit: limit
        )
    }
}
