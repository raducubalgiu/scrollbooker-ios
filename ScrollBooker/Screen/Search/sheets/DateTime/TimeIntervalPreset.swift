//
//  TimeIntervalPreset.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

enum TimeIntervalPreset: CaseIterable, Equatable {
    case anytime
    case morning
    case lunch
    case evening
    case custom

    var start: String? {
        switch self {
            case .morning: return "09:00"
            case .lunch: return "12:00"
            case .evening: return "18:00"
            case .anytime, .custom: return nil
        }
    }

    var end: String? {
        switch self {
            case .morning: return "12:00"
            case .lunch: return "18:00"
            case .evening: return "22:00"
            case .anytime, .custom: return nil
        }
    }

    var label: String {
        switch self {
            case .anytime: return String(localized: "anytime")
            case .morning: return String(localized: "morning")
            case .lunch: return String(localized: "afternoon")
            case .evening: return String(localized: "evening")
            case .custom: return String(localized: "custom")
        }
    }

    var description: String? {
        guard let start, let end else { return nil }
        return "\(start) - \(end)"
    }
}
