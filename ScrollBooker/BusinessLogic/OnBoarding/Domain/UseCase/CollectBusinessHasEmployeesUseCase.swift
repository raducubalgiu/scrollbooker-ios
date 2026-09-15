//
//  CollectBusinessHasEmployeesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class CollectBusinessHasEmployeesUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(hasEmployees: Bool) async throws -> AuthState {
        try await repository.collectBusinessHasEmployees(hasEmployees: hasEmployees)
    }
}
