//
//  CalendarEvents.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct CalendarEvents: Equatable, Hashable, Sendable {
    let businessShortDomain: String
    let days: [CalendarEventsDay]
}

struct CalendarEventsDay: Equatable, Hashable, Sendable {
    let day: String
    let isBooked: Bool
    let isClosed: Bool
    let slots: [CalendarEventsSlot]
}

struct CalendarEventsSlot: Identifiable, Equatable, Hashable, Sendable {
    var id: String { startDateUtc }

    let slotId: Int?
    let startDateLocale: String
    let endDateLocale: String
    let startDateUtc: String
    let endDateUtc: String
    let isBooked: Bool
    let isBlocked: Bool
    let isLastMinute: Bool
    let lastMinuteDiscount: Decimal?
    let info: CalendarEventsInfo?
}

struct CalendarEventsCustomer: Equatable, Hashable, Sendable {
    let id: Int?
    let fullname: String
    let username: String?
    let avatar: String?
}

struct CalendarEventsInfo: Equatable, Hashable, Sendable {
    let channel: AppointmentChannelEnum?
    let customer: CalendarEventsCustomer?
    let blockedMessage: String?
    let totalPrice: Decimal
    let totalPriceWithDiscount: Decimal
    let totalDiscount: Decimal
    let totalDuration: Int
    let paymentCurrency: Currency
    let products: [CalendarEventsProduct]
}

struct CalendarEventsProduct: Equatable, Hashable, Sendable {
    let productName: String
    let productFullPrice: Decimal
    let productPriceWithDiscount: Decimal
    let productDiscount: Decimal
}
