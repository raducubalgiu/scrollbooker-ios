//
//  CommentApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import Foundation

protocol CommentApiService: Sendable {
    func getCommentsByPostId(postId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<CommentDto>
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
}
