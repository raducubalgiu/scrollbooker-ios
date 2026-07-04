//
//  AuthAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

// MARK: - Protocol
/// Protocol marcat ca Sendable pentru conformarea strictă la modelul de concurență din Swift 6.
protocol AuthAPI: Sendable {
    func login(body: LoginRequestDTO) async throws -> AuthResponse
    func register(body: RegisterRequestDTO) async throws -> AuthResponse
    func refresh(refreshToken: String) async throws -> AuthResponse
    // Eliminat parametrul (token: String) pentru a lăsa AuthInterceptor să injecteze token-ul automat
    func verifyEmail() async throws -> AuthState
}

// MARK: - Implementare
final class AuthAPIImpl: AuthAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func login(body: LoginRequestDTO) async throws -> AuthResponse {
            let dto: AuthResponseDTO = try await client.formUrlEncodedRequest(
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
        // Endpoint-ul de refresh nu folosește interceptorul de Bearer Token (deoarece trimite refreshToken în body)
        let dto: AuthResponseDTO = try await client.request(
            "auth/refresh",
            method: .post,
            body: RefreshTokenRequestDTO(refresh_token: refreshToken)
        )
        return AuthResponse(dto: dto)
    }
    
    func verifyEmail() async throws -> AuthState {
        // Schimbarea este completă: protocolul și clasa au acum aceeași semnătură curată
        let dto: AuthStateDTO = try await client.request(
            "auth/verify-email",
            method: .post
        )
        return AuthState(dto: dto)
    }
}
