//
//  GetBusinessProfileUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

final class GetBusinessProfileUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(username: String) async throws -> BusinessProfile {
        try await repository.getBusinessProfile(username: username)
    }
}
