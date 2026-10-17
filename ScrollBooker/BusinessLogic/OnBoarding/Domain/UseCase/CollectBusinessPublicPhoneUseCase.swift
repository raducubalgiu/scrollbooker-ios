//
//  CollectBusinessPublicPhoneUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

final class CollectBusinessPublicPhoneUseCase {
    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func callAsFunction(phone: String, code: String) async throws -> AuthState {
        try await repository.collectBusinessPublicPhone(phone: phone, code: code)
    }
}
