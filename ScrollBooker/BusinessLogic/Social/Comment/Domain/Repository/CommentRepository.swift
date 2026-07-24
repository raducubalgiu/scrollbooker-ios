//
//  CommentRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

protocol CommentRepository: Sendable {
    func getCommentsByPostId(postId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Comment>
}
