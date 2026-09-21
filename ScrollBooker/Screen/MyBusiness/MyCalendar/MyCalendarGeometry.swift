//
//  MyCalendarGeometry.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation
import CoreGraphics

func parseTimeStringToMinutes(_ value: String?) -> Int? {
    guard let value else { return nil }
    let parts = value.split(separator: ":")
    guard parts.count >= 2, let hour = Int(parts[0]), let minute = Int(parts[1]) else { return nil }
    return hour * 60 + minute
}

func minutesFromDateTimeString(_ value: String?) -> Int? {
    guard let value else { return nil }
    let timePart = value.split(separator: "T").last.map(String.init) ?? value
    return parseTimeStringToMinutes(timePart)
}

func generateTicks(startMinutes: Int, endMinutes: Int, stepMinutes: Int) -> [Int] {
    guard stepMinutes > 0, startMinutes <= endMinutes else { return [] }

    var result: [Int] = []
    var t = startMinutes
    while t <= endMinutes {
        result.append(t)
        t += stepMinutes
    }
    return result
}

func formatMinutesAsClock(_ minutes: Int) -> String {
    let hour = (minutes / 60) % 24
    let minute = minutes % 60
    return String(format: "%02d:%02d", hour, minute)
}

func hourHeight(forSlotDurationMinutes minutes: Int) -> CGFloat {
    let minSlotHeight: CGFloat
    switch minutes {
        case 15: minSlotHeight = 130
        case 30: minSlotHeight = 140
        case 45: minSlotHeight = 150
        default: minSlotHeight = 170
    }

    let computed = (60.0 / CGFloat(minutes)) * minSlotHeight
    return min(max(computed, 120), 260)
}
