//
//  CollectBusinessSchedulesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class CollectBusinessSchedulesUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(schedules: [Schedule]) async throws -> AuthState {
        try await repository.collectBusinessSchedules(schedules: schedules)
    }
}
