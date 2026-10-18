//
//  ProfileSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

enum ProfileSheet: Identifiable, Equatable {
    case menu
    case openingHours
    case contact(ContactInfo)

    var id: String {
        switch self {
            case .menu: return "menu"
            case .openingHours: return "openingHours"
            case .contact: return "contact"
        }
    }
}
