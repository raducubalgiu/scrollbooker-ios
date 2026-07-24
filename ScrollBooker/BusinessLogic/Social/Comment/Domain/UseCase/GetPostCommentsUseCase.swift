//
//  GetPostCommentsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

final class GetPostCommentsUseCase {
    private let repository: CommentRepository

    init(repository: CommentRepository) {
        self.repository = repository
    }

    func callAsFunction(
        postId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Comment> {

        try await repository.getCommentsByPostId(
            postId: postId,
            page: page,
            limit: limit
        )
    }
}
