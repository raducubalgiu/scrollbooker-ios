//
//  FilterModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

@MainActor
final class FilterModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: FilterApiService = {
        FilterAPIImpl(client: apiClient)
    }()

    private lazy var repository: FilterRepository = {
        FilterRepositoryImpl(api: apiService)
    }()

    lazy var getFiltersByServiceUseCase: GetFiltersByServiceUseCase = {
        GetFiltersByServiceUseCase(repository: repository)
    }()
}
