//
//  UserCalendarSettingsRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

final class UserCalendarSettingsRepositoryImpl: UserCalendarSettingsRepository {
    private let api: UserCalendarSettingsApiService

    init(api: UserCalendarSettingsApiService) {
        self.api = api
    }

    func getCalendarSettings(userId: Int) async throws -> UserCalendarSettings {
        let dto = try await api.getCalendarSettings(userId: userId)
        return dto.toDomain()
    }

    func updateSlotDuration(_ minutes: Int) async throws -> UserCalendarSettings {
        let dto = try await api.updateSlotDuration(SlotDurationUpdateRequestDTO(slotDurationMinutes: minutes))
        return dto.toDomain()
    }

    func updateAppointmentGap(_ minutes: Int) async throws -> UserCalendarSettings {
        let dto = try await api.updateAppointmentGap(AppointmentGapUpdateRequestDTO(appointmentGapMinutes: minutes))
        return dto.toDomain()
    }
}
