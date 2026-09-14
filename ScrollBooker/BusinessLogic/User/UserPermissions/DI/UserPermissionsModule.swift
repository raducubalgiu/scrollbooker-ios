//
//  UserPermissionsModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

@MainActor
final class UserPermissionsModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: PermissionsApiService = {
        PermissionsAPIImpl(client: apiClient)
    }()

    private lazy var repository: PermissionRepository = {
        PermissionRepositoryImpl(api: apiService)
    }()

    lazy var getUserPermissionsUseCase: GetUserPermissionsUseCase = {
        GetUserPermissionsUseCase(repository: repository)
    }()
}
