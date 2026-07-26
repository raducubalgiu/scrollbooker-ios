//
//  PostApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import Foundation

protocol PostApiService: Sendable {
    func getExplorePosts(page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto>
    func getFollowingPosts(page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto>
    func getVideoReviews(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto>
    func getUserPosts(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto>
    func likePost(id: Int) async throws -> NoContent
    func unlikePost(id: Int) async throws -> NoContent
    func bookmarkPost(id: Int) async throws -> NoContent
    func unbookmarkPost(id: Int) async throws -> NoContent
}

final class PostAPIImpl: PostApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getExplorePosts(page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "posts/explore",
            method: .get,
            query: query
        )
    }
    
    func getFollowingPosts(page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "posts/following",
            method: .get,
            query: query
        )
    }
    
    func getVideoReviews(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "users/\(userId)/posts/video-reviews",
            method: .get,
            query: query
        )
    }
    
    func getUserPosts(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<PostDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "users/\(userId)/posts",
            method: .get,
            query: query
        )
    }
    
    func likePost(id: Int) async throws -> NoContent {
        return try await client.request(
            "posts/\(id)/likes",
            method: .post
        )
    }
    
    func unlikePost(id: Int) async throws -> NoContent {
        return try await client.request(
            "posts/\(id)/likes",
            method: .delete
        )
    }
    
    func bookmarkPost(id: Int) async throws -> NoContent {
        return try await client.request(
            "posts/\(id)/bookmark-posts",
            method: .post
        )
    }
    
    func unbookmarkPost(id: Int) async throws -> NoContent {
        return try await client.request(
            "posts/\(id)/bookmark-posts",
            method: .delete
        )
    }
}
