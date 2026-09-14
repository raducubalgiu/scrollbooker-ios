//
//  DashboardModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

@MainActor
final class DashboardModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: DashboardApiService = {
        DashboardAPIImpl(client: apiClient)
    }()

    private lazy var repository: DashboardRepository = {
        DashboardRepositoryImpl(api: apiService)
    }()

    lazy var getDashboardBookingUseCase: GetDashboardBookingUseCase = {
        GetDashboardBookingUseCase(repository: repository)
    }()
    
    func makeDashboardViewModel() -> MyDashboardViewModel {
        return MyDashboardViewModel(getDashboardBookingUseCase: getDashboardBookingUseCase)
    }
}
