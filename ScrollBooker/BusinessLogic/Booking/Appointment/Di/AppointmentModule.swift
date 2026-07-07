//
//  AppointmentModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

@MainActor
final class AppointmentModule {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: AppointmentApiService = {
        AppointmentAPIImpl(client: apiClient)
    }()

    private lazy var repository: AppointmentRepository = {
        AppointmentRepositoryImpl(api: apiService)
    }()

    private lazy var getUserAppointmentsUseCase: GetUserAppointmentsUseCase = {
        GetUserAppointmentsUseCase(repository: repository)
    }()

    func makeAppointmentsViewModel() -> AppointmentsViewModel {
        AppointmentsViewModel(
            getUserAppointments: getUserAppointmentsUseCase
        )
    }
}
