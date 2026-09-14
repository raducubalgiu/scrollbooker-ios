//
//  PermissionRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class PermissionRepositoryImpl: PermissionRepository {
    private let api: PermissionsApiService

    init(api: PermissionsApiService) {
        self.api = api
    }

    func getUserPermissions() async throws -> [Permission] {
        let dtos = try await api.userPermissions()
        return dtos.map { Permission(dto: $0) }
    }
}
