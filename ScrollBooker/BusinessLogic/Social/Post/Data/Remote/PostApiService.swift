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
}
