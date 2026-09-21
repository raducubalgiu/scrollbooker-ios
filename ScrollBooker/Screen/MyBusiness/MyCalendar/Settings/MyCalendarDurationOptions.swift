//
//  MyCalendarDurationOptions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct MyCalendarDurationOption: Identifiable {
    let minutes: Int
    let label: String
    var id: Int { minutes }
}

enum MyCalendarDurationOptions {
    static let slotDurationOptions: [MyCalendarDurationOption] = [
        MyCalendarDurationOption(minutes: 30, label: String(localized: "minutes30")),
        MyCalendarDurationOption(minutes: 45, label: String(localized: "minutes45")),
        MyCalendarDurationOption(minutes: 60, label: String(localized: "hour1")),
        MyCalendarDurationOption(minutes: 90, label: String(localized: "hour1Minutes30"))
    ]

    static let appointmentGapOptions: [MyCalendarDurationOption] = [
        MyCalendarDurationOption(minutes: 0, label: String(localized: "noGap")),
        MyCalendarDurationOption(minutes: 5, label: String(localized: "minutes5")),
        MyCalendarDurationOption(minutes: 10, label: String(localized: "minutes10")),
        MyCalendarDurationOption(minutes: 15, label: String(localized: "minutes15"))
    ]

    static func label(forSlotDuration minutes: Int) -> String {
        slotDurationOptions.first { $0.minutes == minutes }?.label ?? ""
    }

    static func label(forGap minutes: Int) -> String {
        appointmentGapOptions.first { $0.minutes == minutes }?.label ?? ""
    }
}
