//
//  ShareBusinessProfileUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

final class ShareBusinessProfileUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, channel: ShareChannelEnum) async throws -> NoContent {
        let request = ShareRequest(channel: channel)
        return try await repository.shareBusinessProfile(businessId: businessId, request: request)
    }
}
