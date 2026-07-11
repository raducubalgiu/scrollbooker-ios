//
//  ScheduleModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

@MainActor
final class ScheduleModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ScheduleApiService = {
        ScheduleAPIImpl(client: apiClient)
    }()

    private lazy var repository: ScheduleRepository = {
        ScheduleRepositoryImpl(api: apiService)
    }()
    
    lazy var getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase = {
        GetSchedulesByUserIdUseCase(repository: repository)
    }()
    
    lazy var updateSchedulesUseCase: UpdateSchedulesUseCase = {
        UpdateSchedulesUseCase(repository: repository)
    }()
    
    func makeMySchedulesViewModel(session: SessionManager) -> MySchedulesViewModel {
        MySchedulesViewModel(
            session: session,
            getSchedulesByUserIdUseCase: getSchedulesByUserIdUseCase,
            updateSchedulesUseCase: updateSchedulesUseCase
        )
    }
}
