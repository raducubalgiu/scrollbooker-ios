//
//  AvailableDayDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct AvailableDayDto: Decodable {
    let isClosed: Bool
    let availableSlots: [SlotDto]
    
    enum CodingKeys: String, CodingKey {
        case isClosed = "is_closed"
        case availableSlots = "available_slots"
    }
}

struct SlotDto: Decodable {
    let startDateUtc: String
    let endDateUtc: String
    let startDateLocale: String
    let endDateLocale: String
    let isLastMinute: Bool
    let lastMinuteDiscount: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case startDateUtc = "start_date_utc"
        case endDateUtc = "end_date_utc"
        case startDateLocale = "start_date_locale"
        case endDateLocale = "end_date_locale"
        case isLastMinute = "is_last_minute"
        case lastMinuteDiscount = "last_minute_discount"
    }
}
