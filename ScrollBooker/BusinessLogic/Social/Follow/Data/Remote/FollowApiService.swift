//
//  FollowApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

protocol FollowApiService: Sendable {
    func getUserFollowers(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<UserSocialDto>
    func getUserFollowings(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponseDTO<UserSocialDto>
}

final class FollowAPIImpl: FollowApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getUserFollowers(
        userId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponseDTO<UserSocialDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "users/\(userId)/followers",
            method: .get,
            query: query
        )
    }
    
    func getUserFollowings(
        userId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponseDTO<UserSocialDto> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        return try await client.request(
            "users/\(userId)/followers",
            method: .get,
            query: query
        )
    }
}
