//
//  CommentRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

protocol CommentRepository: Sendable {
    func getCommentsByPostId(postId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Comment>
    func getRepliesByCommentId(postId: Int, parentId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Comment>
    func createComment(postId: Int, request: CreateCommentRequest) async throws -> Comment
    func likeComment(commentId: Int) async throws -> NoContent
    func unlikeComment(commentId: Int) async throws -> NoContent
}
