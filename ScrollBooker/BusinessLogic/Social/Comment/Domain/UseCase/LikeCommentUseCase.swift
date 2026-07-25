//
//  LikeCommentUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

final class LikeCommentUseCase {
    private let repository: CommentRepository

    init(repository: CommentRepository) {
        self.repository = repository
    }

    func callAsFunction(commentId: Int) async throws -> NoContent {
        return try await repository.likeComment(commentId: commentId)
    }
}
