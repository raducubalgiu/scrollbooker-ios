//
//  LoginWithGoogleUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

final class SignInWithGoogleUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction(idToken: String, roleName: String? = nil) async throws -> AuthResponse {
        try await repository.signInWithGoogle(idToken: idToken, roleName: roleName)
    }
}
