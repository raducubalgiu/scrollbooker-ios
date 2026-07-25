//
//  GetCommentRepliesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

final class GetCommentRepliesUseCase {
    private let repository: CommentRepository

    init(repository: CommentRepository) {
        self.repository = repository
    }

    func callAsFunction(
        postId: Int,
        parentId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Comment> {
        try await repository.getRepliesByCommentId(
            postId: postId,
            parentId: parentId,
            page: page,
            limit: limit
        )
    }
}
