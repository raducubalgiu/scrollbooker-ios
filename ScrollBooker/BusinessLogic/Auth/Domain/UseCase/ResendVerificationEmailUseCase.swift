//
//  ResendVerificationEmailUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.10.2026.
//

final class ResendVerificationEmailUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> String {
        try await repository.resendVerificationEmail()
    }
}
