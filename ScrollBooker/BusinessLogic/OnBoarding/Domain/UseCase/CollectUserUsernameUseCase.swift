//
//  CollectUserUsernameUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class CollectUserUsernameUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(username: String) async throws -> AuthState {
        try await repository.collectUserUsername(username: username)
    }
}
