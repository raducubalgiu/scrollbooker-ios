//
//  UserCalendarSettings.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct UserCalendarSettings: Equatable, Hashable, Sendable {
    let userId: Int
    let slotDurationMinutes: Int
    let appointmentGapMinutes: Int
}
