//
//  NotificationRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

final class NotificationRepositoryImpl: NotificationRepository {
    private let api: NotificationApiService
        
    init(api: NotificationApiService) {
        self.api = api
    }
    
    func getUserNotifications(page: Int, limit: Int) async throws -> PaginatedResponse<Notification> {
        let dto = try await api.getUserNotifications(page: page, limit: limit)
        
        return PaginatedResponse(dto) {
            Notification(dto: $0)
        }
    }
}
