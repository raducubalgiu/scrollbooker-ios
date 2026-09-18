//
//  DeletePostUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class DeletePostUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> NoContent {
        try await repository.deletePost(id: id)
    }
}
