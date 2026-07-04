//
//  AvailableDayDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct AvailableDayDto: Codable {
    let is_closed: Bool
    let available_slots: [SlotDto]
}

// MARK: - Slot DTO
struct SlotDto: Codable {
    let start_date_utc: String
    let end_date_utc: String
    let start_date_locale: String
    let end_date_locale: String
    let is_last_minute: Bool
    let last_minute_discount: Decimal? 
}
