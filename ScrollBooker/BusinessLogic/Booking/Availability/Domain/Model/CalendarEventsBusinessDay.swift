//
//  CalendarEventsBusinessDay.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct CalendarEventsBusinessDay: Equatable, Hashable, Sendable {
    let businessShortDomain: String
    let employees: [CalendarEventsBusinessEmployee]
}

struct CalendarEventsBusinessEmployee: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
    let profession: String
    let slots: [CalendarEventsSlot]
}
