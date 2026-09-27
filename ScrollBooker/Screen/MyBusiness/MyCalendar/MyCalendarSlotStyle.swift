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
    let isBefore: Bool
}

func resolveSlotStyle(for slot: CalendarEventsSlot, domainColor: Color) -> MyCalendarSlotStyle {
    let isBefore = (slot.startDate ?? .distantFuture) < Date()

    let baseColor: Color
    let bgOpacity: Double
    let borderOpacity: Double

    if slot.isBooked, slot.info?.channel == .scrollBooker {
        baseColor = .primarySB
        bgOpacity = 0.2;
        borderOpacity = 0.25
    } else if slot.isBooked {
        baseColor = domainColor
        bgOpacity = 0.2;
        borderOpacity = 0.25
    } else if slot.isBlocked, slot.info?.isExternal == true {
        baseColor = domainColor
        bgOpacity = 0.2;
        borderOpacity = 0.25
    } else if slot.isBlocked {
        baseColor = .errorSB
        bgOpacity = 0.2;
        borderOpacity = 0.25
    } else if slot.isLastMinute {
        baseColor = .ratingSB
        bgOpacity = 0.2;
        borderOpacity = 0.25
    } else {
        baseColor = .surfaceSB
        bgOpacity = 1.0;
        borderOpacity = 0.6
    }

    let isSpecialState = slot.isBooked || slot.isBlocked || slot.isLastMinute

    return MyCalendarSlotStyle(
        backgroundColor: baseColor.opacity(bgOpacity),
        lineColor: baseColor.opacity(0.55),
        borderColor: isSpecialState ? baseColor.opacity(borderOpacity) : Color.dividerSB.opacity(borderOpacity),
        borderWidth: 2,
        isBefore: isBefore
    )
}
