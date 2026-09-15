//
//  CollectBusinessServicesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class CollectBusinessServicesUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(serviceIds: [Int]) async throws -> AuthState {
        try await repository.collectBusinessServices(serviceIds: serviceIds)
    }
}
