//
//  NotificationModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

@MainActor
final class NotificationModule {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: NotificationApiService = {
        NotificationAPIImpl(client: apiClient)
    }()

    private lazy var repository: NotificationRepository = {
        NotificationRepositoryImpl(api: apiService)
    }()

    private lazy var getUserNotificationsUseCase: GetUserNotificationsUseCase = {
        GetUserNotificationsUseCase(repository: repository)
    }()

    func makeNotificationsViewModel() -> InboxViewModel {
        InboxViewModel(
            getUserNotifications: getUserNotificationsUseCase
        )
    }
}
