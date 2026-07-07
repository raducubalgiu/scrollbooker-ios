//
//  UserProfileApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

protocol UserProfileApiService: Sendable {
    func getUserProfile(username: String) async throws -> UserProfileDTO
}

final class UserProfileApiImpl: UserProfileApiService {

    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getUserProfile(username: String) async throws -> UserProfileDTO {
        try await client.request(
            "users/\(username)/user-profile",
            method: .get
        )
    }
}

