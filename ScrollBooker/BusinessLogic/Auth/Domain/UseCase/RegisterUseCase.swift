//
//  RegisterUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

final class RegisterUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction(email: String, password: String, roleName: String) async throws -> AuthResponse {
        try await repository.register(email: email, password: password, roleName: roleName)
    }
}
