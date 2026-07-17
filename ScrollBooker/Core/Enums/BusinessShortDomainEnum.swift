//
//  BusinessShortDomainEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import SwiftUI

enum BusinessShortDomainEnum: String, Decodable {
    case beauty = "Beauty"
    case auto = "Auto"
    case medical = "Medical"
    case unknown = "Unknown"
    
    init(fromKeyOrUnknown key: String?) {
        guard let key = key else {
            self = .unknown
            return
        }
        if let matchingCase = BusinessShortDomainEnum.allCases.first(where: { $0.rawValue.caseInsensitiveCompare(key) == .orderedSame }) {
            self = matchingCase
        } else {
            self = .unknown
        }
    }
    
    var domainColor: Color {
        switch self {
        case .beauty:
            return .beautySB
        case .auto:
            return .autoSB
        case .medical:
            return .medicalSB
        case .unknown:
            return .gray
        }
    }
}

extension BusinessShortDomainEnum: CaseIterable {}
