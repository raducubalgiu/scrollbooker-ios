//
//  GetUserBookmarkedPostsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

final class GetUserBookmarkedPostsUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(
        userId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Post> {

        try await repository.getUserBookmarkedPosts(
            userId: userId,
            page: page,
            limit: limit
        )
    }
}
