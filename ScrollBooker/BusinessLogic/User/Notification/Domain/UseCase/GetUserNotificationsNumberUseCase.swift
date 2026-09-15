//
//  GetUserNotificationsNumberUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class GetUserNotificationsNumberUseCase {
    private let repository: NotificationRepository

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> Int {
        try await repository.getUserNotificationsNumber()
    }
}
