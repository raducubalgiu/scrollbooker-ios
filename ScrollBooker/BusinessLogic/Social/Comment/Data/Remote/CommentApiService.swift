//
//  CommentApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

protocol CommentApiService: Sendable {
    func getCommentsByPostId(postId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<CommentDto>
    func getRepliesByCommentId(postId: Int, parentId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<CommentDto>
    func createComment(postId: Int, request: CreateCommentRequest) async throws -> CommentDto
    func likeComment(commentId: Int) async throws -> NoContent
    func unlikeComment(commentId: Int) async throws -> NoContent
}

final class CommentAPIImpl: CommentApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getCommentsByPostId(postId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<CommentDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "posts/\(postId)/comments",
            method: .get,
            query: query
        )
    }
    
    func getRepliesByCommentId(
        postId: Int,
        parentId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponseDTO<CommentDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "posts/\(postId)/comments/\(parentId)/replies",
            method: .get,
            query: query
        )
    }
    
    func createComment(postId: Int, request: CreateCommentRequest) async throws -> CommentDto {
        try await client.request(
            "posts/\(postId)/comments",
            method: .post,
            body: request
        )
    }
    
    func likeComment(commentId: Int) async throws -> NoContent {
        try await client.request(
            "comments/\(commentId)/likes",
            method: .post
        )
    }
    
    func unlikeComment(commentId: Int) async throws -> NoContent {
        try await client.request(
            "comments/\(commentId)/likes",
            method: .delete
        )
    }
}
