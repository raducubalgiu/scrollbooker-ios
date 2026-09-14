//
//  AuthApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

protocol AuthApiService: Sendable {
    func login(body: LoginRequestDTO) async throws -> AuthResponseDTO
    func register(body: RegisterRequestDTO) async throws -> AuthResponseDTO
    func refresh(refreshToken: String) async throws -> AuthResponseDTO
    func verifyEmail() async throws -> AuthStateDTO
}

final class AuthAPIImpl: AuthApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func login(body: LoginRequestDTO) async throws -> AuthResponseDTO {
        try await client.formUrlEncodedRequest(
            "auth/login",
            fields: [
                "username": body.username,
                "password": body.password
            ]
        )
    }

    func register(body: RegisterRequestDTO) async throws -> AuthResponseDTO {
        try await client.request(
            "auth/register",
            method: .post,
            body: body
        )
    }

    func refresh(refreshToken: String) async throws -> AuthResponseDTO {
        // Endpoint-ul de refresh nu folosește interceptorul de Bearer Token (deoarece trimite refreshToken în body)
        try await client.request(
            "auth/refresh",
            method: .post,
            body: RefreshTokenRequestDTO(refresh_token: refreshToken)
        )
    }

    func verifyEmail() async throws -> AuthStateDTO {
        try await client.request(
            "auth/verify-email",
            method: .post
        )
    }
}
