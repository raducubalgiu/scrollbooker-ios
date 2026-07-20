//
//  BookingSourceAnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

enum BookingSourceEnum: String, CaseIterable {
    case bookAgain = "book_again"
    
    case exploreFeed = "explore_feed"
    case followingFeed = "following_feed"
    
    case profile = "profile"
    case profileGridPostDetail = "profile_grid_post_detail"
    case profileBookmarksPostDetail = "profile_bookmarks_post_detail"
    
    case search = "search"
    case searchBusinessProfile = "search_business_profile"
    
    static func fromKey(_ key: String) -> BookingSourceEnum? {
        return BookingSourceEnum(rawValue: key)
    }
    
    static func fromKeys(_ keys: [String]) -> [BookingSourceEnum] {
        return keys.compactMap { BookingSourceEnum(rawValue: $0) }
    }
}
