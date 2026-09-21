//
//  ServiceModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

@MainActor
final class ServiceModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ServicesApiService = {
        ServicesAPIImpl(client: apiClient)
    }()

    private lazy var repository: ServiceRepository = {
        ServiceRepositoryImpl(api: apiService)
    }()

    lazy var getServicesByServiceDomainUseCase: GetServicesByServiceDomainUseCase = {
        GetServicesByServiceDomainUseCase(repository: repository)
    }()
}
