//
//  CollectClientGenderUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class CollectClientGenderUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(gender: String) async throws -> AuthState {
        try await repository.collectClientGender(gender: gender)
    }
}
