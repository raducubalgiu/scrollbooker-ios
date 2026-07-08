//
//  NotificationRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

protocol NotificationRepository: Sendable {
    func getUserNotifications(page: Int, limit: Int) async throws -> PaginatedResponse<Notification>
}
