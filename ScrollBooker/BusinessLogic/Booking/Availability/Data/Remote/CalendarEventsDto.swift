//
//  CalendarEventsDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct CalendarEventsDto: Decodable {
    let businessShortDomain: String
    let days: [CalendarEventsDayDto]

    enum CodingKeys: String, CodingKey {
        case businessShortDomain = "business_short_domain"
        case days
    }
}

struct CalendarEventsDayDto: Decodable {
    let day: String
    let isBooked: Bool
    let isClosed: Bool
    let slots: [CalendarEventsSlotDto]

    enum CodingKeys: String, CodingKey {
        case day
        case isBooked = "is_booked"
        case isClosed = "is_closed"
        case slots
    }
}

struct CalendarEventsSlotDto: Decodable {
    let id: Int?
    let startDateLocale: String
    let endDateLocale: String
    let startDateUtc: String
    let endDateUtc: String
    let isBooked: Bool
    let isBlocked: Bool
    let isLastMinute: Bool

    @LossyOptionalDecimal
    var lastMinuteDiscount: Decimal?

    let info: CalendarEventsInfoDto?

    enum CodingKeys: String, CodingKey {
        case id
        case startDateLocale = "start_date_locale"
        case endDateLocale = "end_date_locale"
        case startDateUtc = "start_date_utc"
        case endDateUtc = "end_date_utc"
        case isBooked = "is_booked"
        case isBlocked = "is_blocked"
        case isLastMinute = "is_last_minute"
        case lastMinuteDiscount = "last_minute_discount"
        case info
    }
}

struct CalendarEventsCustomerDto: Decodable {
    let id: Int?
    let fullname: String
    let username: String?
    let avatar: String?
}

struct CalendarEventsInfoDto: Decodable {
    let channel: String
    let customer: CalendarEventsCustomerDto?
    let blockedMessage: String?

    @LossyDecimal
    var totalPrice: Decimal

    @LossyDecimal
    var totalPriceWithDiscount: Decimal

    @LossyDecimal
    var totalDiscount: Decimal

    let totalDuration: Int
    let paymentCurrency: CurrencyDto
    let products: [CalendarEventsProductDto]

    enum CodingKeys: String, CodingKey {
        case channel
        case customer
        case blockedMessage = "blocked_message"
        case totalPrice = "total_price"
        case totalPriceWithDiscount = "total_price_with_discount"
        case totalDiscount = "total_discount"
        case totalDuration = "total_duration"
        case paymentCurrency = "payment_currency"
        case products
    }
}

struct CalendarEventsProductDto: Decodable {
    let productName: String

    @LossyDecimal
    var productFullPrice: Decimal

    @LossyDecimal
    var productPriceWithDiscount: Decimal

    @LossyDecimal
    var productDiscount: Decimal

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productFullPrice = "product_full_price"
        case productPriceWithDiscount = "product_price_with_discount"
        case productDiscount = "product_discount"
    }
}
