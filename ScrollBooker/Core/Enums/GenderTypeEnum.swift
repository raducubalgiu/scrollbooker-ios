//
//  GenderEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

enum GenderTypeEnum: String, Codable, Sendable, CaseIterable {
    case male = "male"
    case female = "female"
    case other = "other"

    static func fromKey(_ key: String) -> GenderTypeEnum? {
        return GenderTypeEnum(rawValue: key)
    }
    
    static func fromKeys(_ keys: [String]) -> [GenderTypeEnum] {
        return keys.compactMap { GenderTypeEnum(rawValue: $0) }
    }
    
    var label: String {
        switch self {
            case .male: return String(localized: "gender_male", defaultValue: "Masculin")
            case .female: return String(localized: "gender_female", defaultValue: "Feminin")
            case .other: return String(localized: "gender_other", defaultValue: "Altul / Nespecificat")
        }
    }
}
