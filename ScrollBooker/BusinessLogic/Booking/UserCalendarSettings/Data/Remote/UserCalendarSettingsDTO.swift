//
//  UserCalendarSettingsDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct UserCalendarSettingsDTO: Decodable {
    let userId: Int
    let slotDurationMinutes: Int
    let appointmentGapMinutes: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case slotDurationMinutes = "slot_duration_minutes"
        case appointmentGapMinutes = "appointment_gap_minutes"
    }
}

struct SlotDurationUpdateRequestDTO: Encodable {
    let slotDurationMinutes: Int

    enum CodingKeys: String, CodingKey {
        case slotDurationMinutes = "slot_duration_minutes"
    }
}

struct AppointmentGapUpdateRequestDTO: Encodable {
    let appointmentGapMinutes: Int

    enum CodingKeys: String, CodingKey {
        case appointmentGapMinutes = "appointment_gap_minutes"
    }
}
