//
//  AvailableDayMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension AvailableDay {
    init(dto: AvailableDayDto) {
        self.isClosed = dto.is_closed
        self.availableSlots = dto.available_slots.map { Slot(dto: $0) }
    }
}

extension Slot {
    init(dto: SlotDto) {
        self.startDateUtc = dto.start_date_utc
        self.endDateUtc = dto.end_date_utc
        self.startDateLocale = dto.start_date_locale
        self.endDateLocale = dto.end_date_locale
        self.isLastMinute = dto.is_last_minute
        self.lastMinuteDiscount = dto.last_minute_discount
    }
}
