//
//  MyCalendarSlotStyle.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarSlotStyle {
    let backgroundColor: Color
    let lineColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let isEnabled: Bool
    let isBefore: Bool
}

private let calendarEventsDateTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

extension CalendarEventsSlot {
    var startDate: Date? { calendarEventsDateTimeFormatter.date(from: startDateLocale) }
    var endDate: Date? { calendarEventsDateTimeFormatter.date(from: endDateLocale) }

    var isFreeSlot: Bool {
        let isBeforeNow = (startDate ?? .distantFuture) < Date()
        return !isBooked && !isBlocked && !isLastMinute && !isBeforeNow
    }
}

func resolveSlotStyle(for slot: CalendarEventsSlot, domainColor: Color) -> MyCalendarSlotStyle {
    let isBefore = (slot.startDate ?? .distantFuture) < Date()

    let baseColor: Color
    let bgOpacity: Double
    let lineOpacity: Double
    let borderOpacity: Double

    if slot.isBooked, slot.info?.channel == .scrollBooker {
        baseColor = .primarySB
        bgOpacity = 0.18; lineOpacity = 0.35; borderOpacity = 0.5
    } else if slot.isBooked {
        baseColor = domainColor
        bgOpacity = 0.18; lineOpacity = 0.35; borderOpacity = 0.5
    } else if slot.isBlocked {
        baseColor = .errorSB
        bgOpacity = 0.14; lineOpacity = 0.9; borderOpacity = 0.5
    } else if slot.isLastMinute {
        baseColor = .ratingSB
        bgOpacity = 0.20; lineOpacity = 0.35; borderOpacity = 0.5
    } else {
        baseColor = .surfaceSB
        bgOpacity = 1.0; lineOpacity = 1.0; borderOpacity = 0.6
    }

    let isSpecialState = slot.isBooked || slot.isBlocked || slot.isLastMinute

    let isEnabled: Bool
    if slot.isBooked {
        isEnabled = true
    } else if isBefore || slot.isBlocked || slot.isLastMinute {
        isEnabled = false
    } else {
        isEnabled = true
    }

    return MyCalendarSlotStyle(
        backgroundColor: baseColor.opacity(bgOpacity),
        lineColor: baseColor.opacity(lineOpacity),
        borderColor: isSpecialState ? baseColor.opacity(borderOpacity) : Color.dividerSB.opacity(borderOpacity),
        borderWidth: 1,
        isEnabled: isEnabled,
        isBefore: isBefore
    )
}
