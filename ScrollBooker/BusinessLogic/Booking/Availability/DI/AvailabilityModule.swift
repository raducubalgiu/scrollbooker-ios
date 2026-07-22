//
//  AvailabilityModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

@MainActor
final class AvailabilityModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: AvailabilityApiService = {
        AvailabilityAPIImpl(client: apiClient)
    }()

    private lazy var repository: AvailabilityRepository = {
        AvailabilityRepositoryImpl(api: apiService)
    }()
    
    lazy var getUserAvailableDaysUseCase: GetUserAvailableDaysUseCase = {
        GetUserAvailableDaysUseCase(repository: repository)
    }()
    
    lazy var getUserAvailableTimeslotsUseCase: GetUserAvailableTimeslotsUseCase = {
        GetUserAvailableTimeslotsUseCase(repository: repository)
    }()
}
