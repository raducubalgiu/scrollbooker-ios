//
//  CreateCommentUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

final class CreateCommentUseCase {
    private let repository: CommentRepository

    init(repository: CommentRepository) {
        self.repository = repository
    }

    func callAsFunction(
        postId: Int,
        text: String,
        parentId: Int? = nil,
        replyToCommentId: Int? = nil
    ) async throws -> Comment {
        let request = CreateCommentRequest(
            text: text,
            parentId: parentId,
            replyToCommentId: replyToCommentId
        )

        return try await repository.createComment(postId: postId, request: request)
    }
}
