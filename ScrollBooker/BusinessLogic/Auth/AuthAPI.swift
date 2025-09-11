//
//  AuthAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

protocol AuthAPI {
    func login(body: LoginRequestDTO) async throws -> AuthResponse
    func register(body: RegisterRequestDTO) async throws -> AuthResponse
    func refresh(refreshToken: String) async throws -> AuthResponse
    func verifyEmail(token: String) async throws -> AuthState
}

final class AuthAPIImpl: AuthAPI {
    private let client: APIClient
    init(client: APIClient) {
        self.client = client
    }
    
    func login(body: LoginRequestDTO) async throws -> AuthResponse {
        let dto: AuthResponseDTO = try await client.multiPartRequest(
            "auth/login",
            fields: [
                "username": body.username,
                "password": body.password
            ]
        )
        return AuthResponse(dto: dto)
    }
    
    func register(body: RegisterRequestDTO) async throws -> AuthResponse {
        let dto: AuthResponseDTO = try await client.request(
            "auth/register",
            method: .post,
            body: body
        )
        return AuthResponse(dto: dto)
    }
    
    func refresh(refreshToken: String) async throws -> AuthResponse {
        let dto: AuthResponseDTO = try await client.request(
            "auth/refresh",
            method: .post,
            body: RefreshTokenRequestDTO(refresh_token: refreshToken)
        )
        return AuthResponse(dto: dto)
    }
    
    func verifyEmail(token: String) async throws -> AuthState {
        let dto: AuthStateDTO = try await client.request(
            "auth/verify-email",
            method: .post,
            bearer: token
        )
        return AuthState(dto: dto)
    }
}
