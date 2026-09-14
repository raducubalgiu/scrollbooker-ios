//
//  CalendarEventsBusinessDayMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

extension CalendarEventsBusinessDay {
    init(dto: CalendarEventsBusinessResponseDto) {
        self.businessShortDomain = dto.businessShortDomain
        self.employees = dto.employees.map { CalendarEventsBusinessEmployee(dto: $0) }
    }
}

extension CalendarEventsBusinessEmployee {
    init(dto: CalendarEventsBusinessEmployeeDto) {
        self.id = dto.id
        self.fullname = dto.fullname
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.slots = dto.slots.map { CalendarEventsSlot(dto: $0) }
    }
}
