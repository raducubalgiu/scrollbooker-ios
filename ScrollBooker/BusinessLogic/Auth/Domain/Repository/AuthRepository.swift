//
//  AuthRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

protocol AuthRepository: Sendable {
    func login(username: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String, roleName: String) async throws -> AuthResponse
    func refresh(refreshToken: String) async throws -> AuthResponse
    func verifyEmail() async throws -> AuthState
}
