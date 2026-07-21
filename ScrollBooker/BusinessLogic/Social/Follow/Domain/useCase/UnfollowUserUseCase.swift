//
//  UnfollowUserUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import Foundation

final class UnfollowUserUseCase {
    private let repository: FollowRepository

    init(repository: FollowRepository) {
        self.repository = repository
    }

    func callAsFunction(followeeId: Int) async throws -> NoContent {

        try await repository.unfollowUser(
            followeeId: followeeId
        )
    }
}
