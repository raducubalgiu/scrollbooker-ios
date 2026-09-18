//
//  PostViewSourceEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

enum PostViewSourceEnum: String, CaseIterable {
    case exploreFeed = "explore_feed"
    case followingFeed = "following_feed"
    case searchVideoFeed = "search_video_feed"
    case postDetail = "post_detail"
    case bookmarkPostDetail = "bookmark_post_detail"
    case videoReviews = "video_reviews"
    case other = "other"

    static func fromKey(_ key: String) -> PostViewSourceEnum? {
        PostViewSourceEnum(rawValue: key)
    }

    var labelKey: String {
        switch self {
        case .exploreFeed: "analytics_source_explore"
        case .followingFeed: "analytics_source_following"
        case .searchVideoFeed: "analytics_source_search"
        case .postDetail, .bookmarkPostDetail: "analytics_source_profile"
        case .videoReviews: "analytics_source_reviews"
        case .other: "analytics_source_other"
        }
    }

    var localizedLabel: String {
        String(localized: String.LocalizationValue(labelKey))
    }
}
