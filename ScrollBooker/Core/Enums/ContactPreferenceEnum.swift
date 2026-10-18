//
//  ContactPreferenceEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

import Foundation

enum ContactPreferenceEnum: String, Codable, Sendable, CaseIterable {
    case none = "none"
    case phone = "phone"
    case whatsapp = "whatsapp"
    case both = "both"

    static func fromKey(_ key: String) -> ContactPreferenceEnum? {
        ContactPreferenceEnum(rawValue: key)
    }

    var acceptsWhatsapp: Bool {
        self == .whatsapp || self == .both
    }

    var acceptsCalls: Bool {
        self == .phone || self == .both
    }

    static func from(acceptsWhatsapp: Bool, acceptsCalls: Bool) -> ContactPreferenceEnum {
        switch (acceptsWhatsapp, acceptsCalls) {
        case (true, true): return .both
        case (true, false): return .whatsapp
        case (false, true): return .phone
        case (false, false): return .none
        }
    }
}
