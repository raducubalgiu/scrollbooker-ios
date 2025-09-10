//
//  AuthAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

protocol AuthAPI {
    func login(_ body: LoginRequest) async throws -> LoginResponse
    func refresh(refreshToken: String) async throws -> LoginResponse
}

final class AuthAPIImpl: AuthAPI {
    private let client: APIClient
    init(client: APIClient) {
        self.client = client
    }
    
    func login(_ body: LoginRequest) async throws -> LoginResponse {
        let dto: LoginResponseDTO = try await client.multiPartRequest(
            "auth/login",
            fields: [
                "username": body.username,
                "password": body.password
            ]
        )
        return LoginResponse(dto: dto)
    }
    
    func refresh(refreshToken: String) async throws -> LoginResponse {
        let dto: LoginResponseDTO = try await client.request(
            "auth/refresh",
            method: .post,
            body: RefreshTokenRequestDTO(refresh_token: refreshToken)
        )
        return LoginResponse(dto: dto)
    }
}
