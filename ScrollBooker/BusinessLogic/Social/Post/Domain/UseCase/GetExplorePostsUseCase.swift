//
//  GetExplorePostsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Foundation

final class GetExplorePostsUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Post> {

        try await repository.getExplorePosts(
            page: page,
            limit: limit
        )
    }
}
