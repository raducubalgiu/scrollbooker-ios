//
//  NotificationAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

// MARK: - Protocol
/// Protocol marcat ca Sendable pentru conformarea strictă la modelul de concurență din Swift 6.
protocol NotificationAPI: Sendable {
    func getNotifications(page: Int, limit: Int) async throws -> PaginatedResponse<Notification>
    func deleteNotificationById(notificationId: Int) async throws
}

// MARK: - Implementare
final class NotificationAPIImpl: NotificationAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getNotifications(page: Int, limit: Int) async throws -> PaginatedResponse<Notification> {
        // 1) Apelul către APIClient. Am eliminat argumentul `bearer: bearer`.
        let dto: PaginatedResponseDTO<NotificationDTO> = try await client.request(
            "notifications/",
            query: ["page": "\(page)", "limit": "\(limit)"]
        )
        
        // 2) Maparea DTO-ului în modelul de domeniu
        return PaginatedResponse(dto) { Notification(dto: $0) }
    }
    
    func deleteNotificationById(notificationId: Int) async throws {
        // SOLUȚIE SWIFT 6: Specificăm clar tipul `Empty` în stânga, eliminând "as Empty" sau "_ =" inutile
        let _: Empty = try await client.request(
            "notifications/\(notificationId)",
            method: .delete
        )
    }
}
