//
//  SearchUsersUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

final class SearchUsersUseCase {
    private let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func callAsFunction(query: String, roleClient: Bool?) async throws -> [SearchUser] {
        try await repository.searchUsers(query: query, roleClient: roleClient)
    }
}
