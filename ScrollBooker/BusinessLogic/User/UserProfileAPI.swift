//
//  UserProfileAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import Foundation

// MARK: - Protocol
/// Protocol marcat ca Sendable pentru conformarea strictă la modelul de concurență din Swift 6.
protocol UserProfileAPI: Sendable {
    func getUserProfile(userId: Int) async throws -> UserProfile
}

// MARK: - Implementare
final class UserProfileAPIImpl: UserProfileAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getUserProfile(userId: Int) async throws -> UserProfile {
        // Am eliminat argumentul `bearer: bearer`.
        // Noul AuthInterceptor va injecta automat token-ul corect înainte ca cererea să plece.
        let dto: UserProfileDTO = try await client.request(
            "users/\(userId)/user-profile",
            method: .get
        )
        return UserProfile(dto: dto)
    }
}
