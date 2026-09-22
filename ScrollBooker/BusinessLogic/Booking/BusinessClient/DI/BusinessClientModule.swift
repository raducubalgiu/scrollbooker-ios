//
//  BusinessClientModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

@MainActor
final class BusinessClientModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: BusinessClientApiService = {
        BusinessClientAPIImpl(client: apiClient)
    }()

    private lazy var repository: BusinessClientRepository = {
        BusinessClientRepositoryImpl(api: apiService)
    }()

    lazy var getBusinessClientsUseCase: GetBusinessClientsUseCase = {
        GetBusinessClientsUseCase(repository: repository)
    }()

    lazy var createBusinessClientUseCase: CreateBusinessClientUseCase = {
        CreateBusinessClientUseCase(repository: repository)
    }()
}
