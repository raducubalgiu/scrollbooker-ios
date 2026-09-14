//
//  VerifyEmailUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

final class VerifyEmailUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> AuthState {
        try await repository.verifyEmail()
    }
}
