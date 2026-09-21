//
//  UserCalendarSettingsMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

extension UserCalendarSettingsDTO {
    func toDomain() -> UserCalendarSettings {
        UserCalendarSettings(
            userId: userId,
            slotDurationMinutes: slotDurationMinutes,
            appointmentGapMinutes: appointmentGapMinutes
        )
    }
}
