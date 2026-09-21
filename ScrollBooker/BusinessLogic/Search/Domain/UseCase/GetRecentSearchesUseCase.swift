//
//  GetRecentSearchesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

final class GetRecentSearchesUseCase {
    private let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func callAsFunction(limit: Int = 10) async throws -> [RecentSearch] {
        try await repository.getRecentSearches(limit: limit)
    }
}
