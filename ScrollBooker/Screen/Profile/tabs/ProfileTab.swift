//
//  ProfileTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import Foundation

enum ProfileTab: String, CaseIterable, Identifiable {
    case posts
    case products
    case employees
    case bookmarks
    case info
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .posts:
            return "square.grid.3x3"
        case .products:
            return "bag"
        case .employees:
            return "person.2"
        case .bookmarks:
            return "bookmark"
        case .info:
            return "info.circle"
        }
    }
    
    static func getTabs(
        isBusinessOrEmployee: Bool,
        isEmployee: Bool,
        isOwnProfile: Bool
    ) -> [ProfileTab] {
        var tabs: [ProfileTab] = []
        
        tabs.append(.posts)
        if isBusinessOrEmployee { tabs.append(.products) }
        if isBusinessOrEmployee && !isEmployee { tabs.append(.employees) }
        if isOwnProfile { tabs.append(.bookmarks) }
        if isBusinessOrEmployee { tabs.append(.info) }
        
        return tabs
    }
}
