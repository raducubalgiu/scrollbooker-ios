//
//  FilterTypeEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

enum FilterTypeEnum: String, CaseIterable, Equatable, Hashable, Sendable, Codable {
    case options = "options"
    case range = "range"
    
    static func fromKey(_ key: String?) -> FilterTypeEnum? {
        guard let key = key else { return nil }
        return FilterTypeEnum(rawValue: key)
    }
    
    static func fromKeys(_ keys: [String]) -> [FilterTypeEnum] {
        return keys.compactMap { FilterTypeEnum(rawValue: $0) }
    }
}
