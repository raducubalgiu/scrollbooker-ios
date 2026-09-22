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
            case .services: return String(localized: "services")
            case .posts: return String(localized: "title_posts")
            case .employees: return String(localized: "team")
            case .reviews: return String(localized: "reviews")
            case .about: return String(localized: "about")
            }
        }
}
