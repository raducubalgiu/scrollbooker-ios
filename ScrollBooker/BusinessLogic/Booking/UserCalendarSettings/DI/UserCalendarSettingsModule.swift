//
//  UserCalendarSettingsModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

@MainActor
final class UserCalendarSettingsModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: UserCalendarSettingsApiService = {
        UserCalendarSettingsAPIImpl(client: apiClient)
    }()

    private lazy var repository: UserCalendarSettingsRepository = {
        UserCalendarSettingsRepositoryImpl(api: apiService)
    }()

    lazy var getUserCalendarSettingsUseCase: GetUserCalendarSettingsUseCase = {
        GetUserCalendarSettingsUseCase(repository: repository)
    }()

    lazy var updateSlotDurationUseCase: UpdateSlotDurationUseCase = {
        UpdateSlotDurationUseCase(repository: repository)
    }()

    lazy var updateAppointmentGapUseCase: UpdateAppointmentGapUseCase = {
        UpdateAppointmentGapUseCase(repository: repository)
    }()
}
