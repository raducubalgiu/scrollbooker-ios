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
    
    func getVideoReviews(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Post> {
        let dtoResponse = try await api.getVideoReviews(userId: userId, page: page, limit: limit)
        
        return PaginatedResponse(dtoResponse) {
            Post(from: $0)
        }
    }
    
    func getUserPosts(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Post> {
        let dtoResponse = try await api.getVideoReviews(userId: userId, page: page, limit: limit)
        
        return PaginatedResponse(dtoResponse) {
            Post(from: $0)
        }
    }
    
    func likePost(id: Int) async throws -> NoContent {
        return try await api.likePost(id: id)
    }
    
    func unlikePost(id: Int) async throws -> NoContent {
        return try await api.unlikePost(id: id)
    }
    
    func bookmarkPost(id: Int) async throws -> NoContent {
        return try await api.bookmarkPost(id: id)
    }
    
    func unbookmarkPost(id: Int) async throws -> NoContent {
        return try await api.unbookmarkPost(id: id)
    }
}
