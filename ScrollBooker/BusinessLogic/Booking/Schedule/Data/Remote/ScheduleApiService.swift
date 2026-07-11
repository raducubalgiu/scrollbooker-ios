//
//  ScheduleApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

protocol ScheduleApiService: Sendable {
    func getSchedulesByUserId(userId: Int) async throws -> [ScheduleDto]
    func updateSchedules(schedules: [ScheduleDto]) async throws -> [ScheduleDto]
}

final class ScheduleAPIImpl: ScheduleApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getSchedulesByUserId(userId: Int) async throws -> [ScheduleDto] {
        return try await client.request(
            "users/\(userId)/schedules",
            method: .get
        )
    }
    
    func updateSchedules(schedules: [ScheduleDto]) async throws -> [ScheduleDto] {
        return try await client.request(
            "schedules",
            method: .put,
            body: schedules
        )
    }
}
