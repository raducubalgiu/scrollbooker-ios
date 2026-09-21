//
//  UserCalendarSettingsRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

protocol UserCalendarSettingsRepository: Sendable {
    func getCalendarSettings(userId: Int) async throws -> UserCalendarSettings
    func updateSlotDuration(_ minutes: Int) async throws -> UserCalendarSettings
    func updateAppointmentGap(_ minutes: Int) async throws -> UserCalendarSettings
}
