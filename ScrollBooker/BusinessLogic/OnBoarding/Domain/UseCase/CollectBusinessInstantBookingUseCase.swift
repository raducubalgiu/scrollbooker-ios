//
//  CollectBusinessInstantBookingUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import Foundation

final class CollectBusinessInstantBookingUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(instantBooking: Bool) async throws -> AuthState {
        try await repository.collectBusinessInstantBooking(instantBooking: instantBooking)
    }
}
