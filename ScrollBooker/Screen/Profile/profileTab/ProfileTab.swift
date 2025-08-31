//
//  ProfileTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import Foundation

enum ProfileTab: String, CaseIterable, Identifiable {
    case posts = "Posts"
    case products = "Products"
    case reposts = "Reposts"
    case bookmarks = "Bookmarks"
    case info = "Info"
    
    var id: String { rawValue }
    
    var systemImage: String {
        switch self {
        case .posts:
            return "video"
        case .products:
            return "bag"
        case .reposts:
            return "repeat"
        case .bookmarks:
            return "bookmark"
        case .info:
            return "info.circle"
        }
    }
}
