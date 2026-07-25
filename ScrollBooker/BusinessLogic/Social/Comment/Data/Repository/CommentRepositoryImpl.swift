//
//  CommentRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

final class CommentRepositoryImpl: CommentRepository {
    private let api: CommentApiService
        
    init(api: CommentApiService) {
        self.api = api
    }
    
    func getCommentsByPostId(postId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Comment> {
        let dtoResponse = try await api.getCommentsByPostId(postId: postId, page: page, limit: limit)
        
        return try PaginatedResponse(dtoResponse) {
            try Comment(dto: $0)
        }
    }
    
    func getRepliesByCommentId(postId: Int, parentId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Comment> {
        let dtoResponse = try await api.getRepliesByCommentId(
            postId: postId,
            parentId: parentId,
            page: page,
            limit: limit
        )
        
        return try PaginatedResponse(dtoResponse) {
            try Comment(dto: $0)
        }
    }
    
    func createComment(postId: Int, request: CreateCommentRequest) async throws -> Comment {
        let dtoResponse = try await api.createComment(postId: postId, request: request)
        return try Comment(dto: dtoResponse)
    }
    
    func likeComment(commentId: Int) async throws -> NoContent {
        return try await api.likeComment(commentId: commentId)
    }
    
    func unlikeComment(commentId: Int) async throws -> NoContent {
        return try await api.likeComment(commentId: commentId)
    }
}
