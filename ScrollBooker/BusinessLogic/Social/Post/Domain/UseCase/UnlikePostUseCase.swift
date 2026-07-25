//
//  UnlikePostUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

final class UnlikePostUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> NoContent {
        try await repository.unlikePost(id: id)
    }
}
