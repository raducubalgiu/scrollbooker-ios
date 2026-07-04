//
//  ProductTypeEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

enum ProductTypeEnum: String, CaseIterable, Equatable, Hashable, Sendable, Codable {
    case single = "single"
    case pack = "pack"
    case membership = "membership"
    
    static func fromKey(_ key: String?) -> ProductTypeEnum? {
        guard let key = key else { return nil }
        return ProductTypeEnum(rawValue: key)
    }
    
    static func fromKeys(_ keys: [String]) -> [ProductTypeEnum] {
        return keys.compactMap { ProductTypeEnum(rawValue: $0) }
    }
}
