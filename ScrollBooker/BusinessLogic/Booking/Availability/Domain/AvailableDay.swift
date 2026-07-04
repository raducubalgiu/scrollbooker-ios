//
//  AvailableDay.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct AvailableDay: Equatable, Hashable, Sendable {
    let isClosed: Bool
    let availableSlots: [Slot]
}

struct Slot: Identifiable, Equatable, Hashable, Sendable {
    var id: String { startDateUtc }
    
    let startDateUtc: String
    let endDateUtc: String
    let startDateLocale: String
    let endDateLocale: String
    let isLastMinute: Bool
    let lastMinuteDiscount: Decimal?
}
