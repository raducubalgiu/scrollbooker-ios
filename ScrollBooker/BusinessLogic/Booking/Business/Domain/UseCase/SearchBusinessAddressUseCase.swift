//
//  SearchBusinessAddressUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class SearchBusinessAddressUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(query: String) async throws -> [BusinessAddress] {
        try await repository.searchBusinessAddress(query: query)
    }
}
