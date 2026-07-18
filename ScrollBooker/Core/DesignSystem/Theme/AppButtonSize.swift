//
//  AppButtonSize.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

enum AppButtonSize {
    case small
    case medium
    case large
    
    var minHeight: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 48
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .footnote.bold()
        case .medium: return .subheadline.bold()
        case .large: return .body.bold()
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 10
        case .large: return 14
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 18
        case .large: return 24
        }
    }
}
