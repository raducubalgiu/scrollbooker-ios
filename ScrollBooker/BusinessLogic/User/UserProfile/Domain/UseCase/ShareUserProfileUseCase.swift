//
//  ShareUserProfileUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

final class ShareUserProfileUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int, channel: ShareChannelEnum) async throws -> NoContent {
        let request = ShareRequest(channel: channel)
        return try await repository.shareUserProfile(userId: userId, request: request)
    }
}
