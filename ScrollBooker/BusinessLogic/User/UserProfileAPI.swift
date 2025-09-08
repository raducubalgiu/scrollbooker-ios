//
//  UserProfileAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import Foundation

protocol UserProfileAPI {
    func getUserProfile(userId: Int, bearer: String) async throws -> UserProfile
}

final class UserProfileAPIImpl: UserProfileAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getUserProfile(userId: Int, bearer: String) async throws -> UserProfile {
        let dto: UserProfileDTO = try await client.request(
            "users/\(userId)/user-profile",
            method: .get,
            bearer: bearer
        )
        return UserProfile(dto: dto)
    }
}
