//
//  AvailableDayMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension AvailableDay {
    init(dto: AvailableDayDto) {
        self.isClosed = dto.isClosed
        self.availableSlots = dto.availableSlots.map { Slot(dto: $0) }
    }
}

extension Slot {
    init(dto: SlotDto) {
        self.startDateUtc = dto.startDateUtc
        self.endDateUtc = dto.endDateUtc
        self.startDateLocale = dto.startDateUtc
        self.endDateLocale = dto.endDateLocale
        self.isLastMinute = dto.isLastMinute
        self.lastMinuteDiscount = dto.lastMinuteDiscount
    }
}
