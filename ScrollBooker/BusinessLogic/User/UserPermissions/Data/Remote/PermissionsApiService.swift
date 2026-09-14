//
//  PermissionsApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

protocol PermissionsApiService: Sendable {
    func userPermissions() async throws -> [PermissionDTO]
}

final class PermissionsAPIImpl: PermissionsApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func userPermissions() async throws -> [PermissionDTO] {
        try await client.request("auth/user-permissions")
    }
}
