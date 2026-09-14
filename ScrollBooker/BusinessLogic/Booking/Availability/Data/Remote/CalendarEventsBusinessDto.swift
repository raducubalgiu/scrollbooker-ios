//
//  CalendarEventsBusinessDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct CalendarEventsBusinessResponseDto: Decodable {
    let businessShortDomain: String
    let employees: [CalendarEventsBusinessEmployeeDto]

    enum CodingKeys: String, CodingKey {
        case businessShortDomain = "business_short_domain"
        case employees
    }
}

struct CalendarEventsBusinessEmployeeDto: Decodable {
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
    let profession: String
    let slots: [CalendarEventsSlotDto]
}
