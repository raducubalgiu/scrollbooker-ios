//
//  Schedule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Schedule: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let dayOfWeek: String
    let startTime: String?
    let endTime: String?
}

extension Schedule {
    func copy(
        startTime: String? = nil,
        endTime: String? = nil
    ) -> Schedule {
        Schedule(
            id: self.id,
            dayOfWeek: self.dayOfWeek,
            startTime: startTime == "null" ? nil : (startTime ?? self.startTime),
            endTime: endTime == "null" ? nil : (endTime ?? self.endTime)
        )
    }
    
    var isValid: Bool {
        guard let start = startTime, let end = endTime, start != "null", end != "null" else { return true }
        return start < end
    }

    var localizedDayOfWeek: String {
        switch dayOfWeek {
            case "Monday":    return String(localized: "monday", defaultValue: "Luni")
            case "Tuesday":   return String(localized: "tuesday", defaultValue: "Marți")
            case "Wednesday": return String(localized: "wednesday", defaultValue: "Miercuri")
            case "Thursday":  return String(localized: "thursday", defaultValue: "Joi")
            case "Friday":    return String(localized: "friday", defaultValue: "Vineri")
            case "Saturday":  return String(localized: "saturday", defaultValue: "Sâmbătă")
            case "Sunday":    return String(localized: "sunday", defaultValue: "Duminică")
            default:          return dayOfWeek
        }
    }

    var formattedStartTime: String? { Self.formattedTime(startTime) }
    var formattedEndTime: String? { Self.formattedTime(endTime) }

    var isClosed: Bool { formattedStartTime == nil || formattedEndTime == nil }
    var timeRangeDisplay: String {
        guard let start = formattedStartTime, let end = formattedEndTime else {
            return String(localized: "closed")
        }
        return "\(start) - \(end)"
    }

    private static func formattedTime(_ value: String?) -> String? {
        guard let value, value != "null", !value.isEmpty else { return nil }
        return String(value.prefix(5))
    }
}


