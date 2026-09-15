//
//  BusinessTypeModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

@MainActor
final class BusinessTypeModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: BusinessTypeApiService = {
        BusinessTypeAPIImpl(client: apiClient)
    }()

    private lazy var repository: BusinessTypeRepository = {
        BusinessTypeRepositoryImpl(api: apiService)
    }()

    lazy var getAllPaginatedBusinessTypesUseCase: GetAllPaginatedBusinessTypesUseCase = {
        GetAllPaginatedBusinessTypesUseCase(repository: repository)
    }()
}
