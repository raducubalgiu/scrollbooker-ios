//
//  NotificationAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

protocol NotificationAPI {
    func fetch(page: Int, limit: Int, bearer: String) async throws -> PaginatedResponse<Notification>
}

final class NotificationAPIImpl: NotificationAPI {
    private let client: APIClient
    init(client: APIClient) {
        self.client = client
    }
    
    func fetch(page: Int, limit: Int, bearer: String) async throws -> PaginatedResponse<Notification> {
        let dto: PaginatedResponseDTO<NotificationDTO> = try await client.request(
            "notifications/",
            bearer: bearer,
            query: ["page": "\(page)", "limit": "\(limit)"]
        )
        
        return PaginatedResponse(dto) { Notification(dto: $0) }
    }
}
