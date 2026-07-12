//
//  ProfileSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

enum ProfileSheet: Identifiable {
    case menu
    case openingHours
    
    var id: String {
        switch self {
            case .menu: return "menu"
            case .openingHours: return "openingHours"
        }
    }
}
