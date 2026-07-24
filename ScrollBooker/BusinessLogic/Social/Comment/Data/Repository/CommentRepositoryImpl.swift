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
}
