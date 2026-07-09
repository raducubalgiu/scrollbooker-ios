//
//  GetUserFollowersUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

final class GetUserFollowersUseCase {
    private let repository: FollowRepository

    init(repository: FollowRepository) {
        self.repository = repository
    }

    func callAsFunction(
        userId: Int,
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<UserSocial> {

        try await repository.getUserFollowers(
            userId: userId,
            page: page,
            limit: limit
        )
    }
}
