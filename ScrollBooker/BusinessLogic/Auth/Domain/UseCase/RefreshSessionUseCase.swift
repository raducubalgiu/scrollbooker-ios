//
//  RefreshSessionUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

final class RefreshSessionUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction(refreshToken: String) async throws -> AuthResponse {
        try await repository.refresh(refreshToken: refreshToken)
    }
}
