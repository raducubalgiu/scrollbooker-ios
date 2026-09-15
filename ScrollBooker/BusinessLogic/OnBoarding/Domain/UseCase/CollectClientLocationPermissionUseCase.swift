//
//  CollectClientLocationPermissionUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class CollectClientLocationPermissionUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> AuthState {
        try await repository.collectClientLocationPermission()
    }
}
