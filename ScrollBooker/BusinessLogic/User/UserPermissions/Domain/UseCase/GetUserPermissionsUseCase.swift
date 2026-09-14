//
//  GetUserPermissionsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

final class GetUserPermissionsUseCase {
    private let repository: PermissionRepository

    init(repository: PermissionRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> [Permission] {
        try await repository.getUserPermissions()
    }
}
