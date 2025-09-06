//
//  NotificationAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

protocol NotificationAPI {
    func getNotifications(page: Int, limit: Int, bearer: String) async throws -> PaginatedResponse<Notification>
    func deleteNotificationById(notificationId: Int, bearer: String) async throws
}

final class NotificationAPIImpl: NotificationAPI {
    private let client: APIClient
    init(client: APIClient) {
        self.client = client
    }
    
    func getNotifications(page: Int, limit: Int, bearer: String) async throws -> PaginatedResponse<Notification> {
        let dto: PaginatedResponseDTO<NotificationDTO> = try await client.request(
            "notifications/",
            bearer: bearer,
            query: ["page": "\(page)", "limit": "\(limit)"]
        )
        
        return PaginatedResponse(dto) { Notification(dto: $0) }
    }
    
    func deleteNotificationById(notificationId: Int, bearer: String) async throws {
        _ = try await client.request(
            "notifications/\(notificationId)",
            method: .delete,
            bearer: bearer
        ) as Empty
    }
}
