//
//  PostRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Foundation

final class PostRepositoryImpl: PostRepository {
    private let api: PostApiService
        
    init(api: PostApiService) {
        self.api = api
    }
    
    func getExplorePosts(page: Int, limit: Int) async throws -> PaginatedResponse<Post> {
        let dtoResponse = try await api.getExplorePosts(page: page, limit: limit)
        
        return PaginatedResponse(dtoResponse) {
            Post(from: $0)
        }
    }
    
    func getFollowingPosts(page: Int, limit: Int) async throws -> PaginatedResponse<Post> {
        let dtoResponse = try await api.getFollowingPosts(page: page, limit: limit)
        
        return PaginatedResponse(dtoResponse) {
            Post(from: $0)
        }
    }
}
