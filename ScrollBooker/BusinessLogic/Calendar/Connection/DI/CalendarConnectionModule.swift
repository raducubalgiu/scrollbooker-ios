//
//  CalendarConnectionModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import Foundation

@MainActor
final class CalendarConnectionModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: CalendarConnectionApiService = {
        CalendarConnectionAPIImpl(client: apiClient)
    }()

    private lazy var repository: CalendarConnectionRepository = {
        CalendarConnectionRepositoryImpl(api: apiService)
    }()

    private lazy var getCalendarConnectionUseCase: GetCalendarConnectionUseCase = {
        GetCalendarConnectionUseCase(repository: repository)
    }()

    private lazy var connectGoogleCalendarUseCase: ConnectGoogleCalendarUseCase = {
        ConnectGoogleCalendarUseCase(repository: repository)
    }()

    private lazy var disconnectCalendarConnectionUseCase: DisconnectCalendarConnectionUseCase = {
        DisconnectCalendarConnectionUseCase(repository: repository)
    }()

    func makeCalendarConnectionViewModel(toastCenter: ToastCenter) -> CalendarConnectionViewModel {
        CalendarConnectionViewModel(
            getCalendarConnectionUseCase: getCalendarConnectionUseCase,
            connectGoogleCalendarUseCase: connectGoogleCalendarUseCase,
            disconnectCalendarConnectionUseCase: disconnectCalendarConnectionUseCase,
            googleCalendarAuthorizationProvider: GoogleCalendarAuthorizationProvider(),
            toastCenter: toastCenter
        )
    }
}
