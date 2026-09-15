//
//  SearchUsernameUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class SearchUsernameUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(username: String) async throws -> SearchUsername {
        try await repository.searchUsername(username: username)
    }
}
