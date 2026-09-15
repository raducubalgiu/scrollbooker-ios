//
//  NotificationApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

protocol NotificationApiService: Sendable {
    func getUserNotifications(page: Int, limit: Int) async throws -> PaginatedResponseDTO<NotificationDTO>
    func getUserNotificationsNumber() async throws -> Int
}

final class NotificationAPIImpl: NotificationApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getUserNotifications(page: Int, limit: Int) async throws -> PaginatedResponseDTO<NotificationDTO> {
        let query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]

        return try await client.request(
            "notifications",
            method: .get,
            query: query
        )
    }

    func getUserNotificationsNumber() async throws -> Int {
        return try await client.request(
            "notifications/count",
            method: .get
        )
    }
}
