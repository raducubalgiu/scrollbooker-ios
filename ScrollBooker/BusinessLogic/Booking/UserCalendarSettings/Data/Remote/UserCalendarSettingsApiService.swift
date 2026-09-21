//
//  UserCalendarSettingsApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

protocol UserCalendarSettingsApiService: Sendable {
    func getCalendarSettings(userId: Int) async throws -> UserCalendarSettingsDTO
    func updateSlotDuration(_ request: SlotDurationUpdateRequestDTO) async throws -> UserCalendarSettingsDTO
    func updateAppointmentGap(_ request: AppointmentGapUpdateRequestDTO) async throws -> UserCalendarSettingsDTO
}

final class UserCalendarSettingsAPIImpl: UserCalendarSettingsApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getCalendarSettings(userId: Int) async throws -> UserCalendarSettingsDTO {
        return try await client.request(
            "users/\(userId)/calendar-settings",
            method: .get
        )
    }

    func updateSlotDuration(_ request: SlotDurationUpdateRequestDTO) async throws -> UserCalendarSettingsDTO {
        return try await client.request(
            "calendar-settings/slot-duration",
            method: .patch,
            body: request
        )
    }

    func updateAppointmentGap(_ request: AppointmentGapUpdateRequestDTO) async throws -> UserCalendarSettingsDTO {
        return try await client.request(
            "calendar-settings/gap",
            method: .patch,
            body: request
        )
    }
}
