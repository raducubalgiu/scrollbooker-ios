//
//  AppointmentChannelEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

enum AppointmentChannelEnum: String, CaseIterable, Equatable, Hashable, Sendable, Codable {
    case scrollBooker = "scroll_booker"
    case ownClient = "own_client"

    static func fromKey(_ key: String) -> AppointmentChannelEnum? {
        return AppointmentChannelEnum(rawValue: key)
    }

    static func fromKeys(_ keys: [String]) -> [AppointmentChannelEnum] {
        return keys.compactMap { AppointmentChannelEnum(rawValue: $0) }
    }
}
