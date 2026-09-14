//
//  CalendarEventsMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

extension CalendarEvents {
    init(dto: CalendarEventsDto) {
        self.businessShortDomain = dto.businessShortDomain
        self.days = dto.days.map { CalendarEventsDay(dto: $0) }
    }
}

extension CalendarEventsDay {
    init(dto: CalendarEventsDayDto) {
        self.day = dto.day
        self.isBooked = dto.isBooked
        self.isClosed = dto.isClosed
        self.slots = dto.slots.map { CalendarEventsSlot(dto: $0) }
    }
}

extension CalendarEventsSlot {
    init(dto: CalendarEventsSlotDto) {
        self.slotId = dto.id
        self.startDateLocale = dto.startDateLocale
        self.endDateLocale = dto.endDateLocale
        self.startDateUtc = dto.startDateUtc
        self.endDateUtc = dto.endDateUtc
        self.isBooked = dto.isBooked
        self.isBlocked = dto.isBlocked
        self.isLastMinute = dto.isLastMinute
        self.lastMinuteDiscount = dto.lastMinuteDiscount
        self.info = dto.info.map { CalendarEventsInfo(dto: $0) }
    }
}

extension CalendarEventsCustomer {
    init(dto: CalendarEventsCustomerDto) {
        self.id = dto.id
        self.fullname = dto.fullname
        self.username = dto.username
        self.avatar = dto.avatar
    }
}

extension CalendarEventsInfo {
    init(dto: CalendarEventsInfoDto) {
        self.channel = AppointmentChannelEnum.fromKey(dto.channel)
        self.customer = dto.customer.map { CalendarEventsCustomer(dto: $0) }
        self.blockedMessage = dto.blockedMessage
        self.totalPrice = dto.totalPrice
        self.totalPriceWithDiscount = dto.totalPriceWithDiscount
        self.totalDiscount = dto.totalDiscount
        self.totalDuration = dto.totalDuration
        self.paymentCurrency = Currency(dto: dto.paymentCurrency)
        self.products = dto.products.map { CalendarEventsProduct(dto: $0) }
    }
}

extension CalendarEventsProduct {
    init(dto: CalendarEventsProductDto) {
        self.productName = dto.productName
        self.productFullPrice = dto.productFullPrice
        self.productPriceWithDiscount = dto.productPriceWithDiscount
        self.productDiscount = dto.productDiscount
    }
}
