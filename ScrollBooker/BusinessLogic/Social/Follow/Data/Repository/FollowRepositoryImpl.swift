//
//  FollowRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

final class FollowRepositoryImpl: FollowRepository {
    private let api: FollowApiService
        
    init(api: FollowApiService) {
        self.api = api
    }
    
    func getUserFollowers(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<UserSocial> {
        let dtoResponse = try await api.getUserFollowers(userId: userId, page: page, limit: limit)
        
        return try PaginatedResponse(dtoResponse) {
            try UserSocial(dto: $0)
        }
    }
    
    func getUserFollowings(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<UserSocial> {
        let dtoResponse = try await api.getUserFollowings(userId: userId, page: page, limit: limit)
        
        return try PaginatedResponse(dtoResponse) {
            try UserSocial(dto: $0)
        }
    }
    
    func followUser(followeeId: Int) async throws -> NoContent {
        return try await api.followUser(followeeId: followeeId)
    }
    
    func unfollowUser(followeeId: Int) async throws -> NoContent {
        return try await api.unfollowUser(followeeId: followeeId)
    }
}
