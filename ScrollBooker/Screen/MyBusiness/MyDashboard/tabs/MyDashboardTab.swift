//
//  MyDashboardTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

enum MyDashboardTab: CaseIterable, Identifiable {
    case appointments
    case posts

    var id: Self { self }

    var title: String {
        switch self {
        case .appointments: return String(localized: "appointments")
        case .posts: return String(localized: "title_posts")
        }
    }
}
