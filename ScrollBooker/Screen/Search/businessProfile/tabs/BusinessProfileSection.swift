//
//  BusinessProfileSection.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import Foundation

enum BusinessProfileSection: String, CaseIterable, Identifiable {
    case services, social, team, reviews, about
    var id: String { rawValue }

    var title: String {
        switch self {
        case .services: return "Servicii"
        case .social: return "Social"
        case .team: return "Echipa"
        case .reviews: return "Recenzii"
        case .about: return "About"
        }
    }
}
