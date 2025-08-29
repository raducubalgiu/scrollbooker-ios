//
//  ReviewLabel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import Foundation
import SwiftUI

enum ReviewLabel: Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    case five
    
    var text: String {
        switch self {
        case .one: return String(localized: "rating_1")
        case .two: return String(localized: "rating_2")
        case .three: return String(localized: "rating_3")
        case .four: return String(localized: "rating_4")
        case .five: return String(localized: "rating_5")
        }
    }
    
    static func from(value: Int) -> ReviewLabel {
        return ReviewLabel(rawValue: value) ?? .three
    }
}
