//
//  BusinessDomainModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import Foundation

@MainActor
final class BusinessDomainModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: BusinessDomainApiService = {
        BusinessDomainAPIImpl(client: apiClient)
    }()

    private lazy var repository: BusinessDomainRepository = {
        BusinessDomainRepositoryImpl(api: apiService)
    }()

    lazy var getAllBusinessDomainsUseCase: GetAllBusinessDomainsUseCase = {
        GetAllBusinessDomainsUseCase(repository: repository)
    }()
}
