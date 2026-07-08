//
//  GetUserNotificationsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

final class GetUserNotificationsUseCase {
    private let repository: NotificationRepository

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func callAsFunction(
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<Notification> {

        try await repository.getUserNotifications(
            page: page,
            limit: limit
        )
    }
}
