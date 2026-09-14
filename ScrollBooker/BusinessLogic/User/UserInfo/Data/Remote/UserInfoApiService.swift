//
//  UserInfoApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

protocol UserInfoApiService: Sendable {
    func userInfo() async throws -> UserInfoDTO
}

final class UserInfoAPIImpl: UserInfoApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func userInfo() async throws -> UserInfoDTO {
        try await client.request("auth/user-info")
    }
}
