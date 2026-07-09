//
//  FollowRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

protocol FollowRepository: Sendable {
    func getUserFollowers(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<UserSocial>
    func getUserFollowings(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<UserSocial>
}
