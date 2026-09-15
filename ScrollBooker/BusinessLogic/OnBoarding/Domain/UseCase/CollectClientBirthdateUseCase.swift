//
//  CollectClientBirthdateUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class CollectClientBirthdateUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(birthdate: String?) async throws -> AuthState {
        try await repository.collectClientBirthdate(birthdate: birthdate)
    }
}
