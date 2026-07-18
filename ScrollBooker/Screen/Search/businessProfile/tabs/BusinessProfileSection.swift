//
//  BusinessProfileSection.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import Foundation

enum BusinessProfileSection: String, CaseIterable, Identifiable {
    case services, posts, employees, reviews, about
        var id: String { self.rawValue }
        
        var title: String {
            switch self {
            case .services: return "Servicii"
            case .posts: return "Posts"
            case .employees: return "Echipă"
            case .reviews: return "Recenzii"
            case .about: return "Despre"
            }
        }
}
