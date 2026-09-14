//
//  AuthRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let api: AuthApiService

    init(api: AuthApiService) {
        self.api = api
    }

    func login(username: String, password: String) async throws -> AuthResponse {
        let dto = try await api.login(body: LoginRequestDTO(username: username, password: password))
        return AuthResponse(dto: dto)
    }

    func register(email: String, password: String, roleName: String) async throws -> AuthResponse {
        let dto = try await api.register(body: RegisterRequestDTO(email: email, password: password, role_name: roleName))
        return AuthResponse(dto: dto)
    }

    func refresh(refreshToken: String) async throws -> AuthResponse {
        let dto = try await api.refresh(refreshToken: refreshToken)
        return AuthResponse(dto: dto)
    }

    func verifyEmail() async throws -> AuthState {
        let dto = try await api.verifyEmail()
        return AuthState(dto: dto)
    }
}
