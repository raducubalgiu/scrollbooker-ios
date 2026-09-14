//
//  LoginUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

final class LoginUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction(username: String, password: String) async throws -> AuthResponse {
        try await repository.login(username: username, password: password)
    }
}
