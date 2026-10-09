//
//  CreatePostViewEventsBulkUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.10.2026.
//

final class CreatePostViewEventsBulkUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(request: PostViewEventsBulkRequest) async throws -> PostViewEventsBulkResponse {
        try await repository.createPostViewEventsBulk(request: request)
    }
}
