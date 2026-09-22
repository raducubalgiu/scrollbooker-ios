//
//  SharePostUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

final class SharePostUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int, channel: ShareChannelEnum) async throws -> NoContent {
        let request = ShareRequest(channel: channel)
        return try await repository.sharePost(id: id, request: request)
    }
}
