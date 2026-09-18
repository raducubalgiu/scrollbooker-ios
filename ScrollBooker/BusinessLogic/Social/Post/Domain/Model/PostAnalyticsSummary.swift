//
//  PostAnalyticsSummary.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

struct PostAnalyticsSummary: Equatable, Hashable, Sendable {
    let postId: Int
    let thumbnailUrl: String?
    let viewsCount: Int
    let uniqueViewersCount: Int
    let watchTimeMs: Int
    let averageWatchTimeMs: Int
    let completionsCount: Int
    let likeCount: Int
    let commentCount: Int
    let shareCount: Int
    let bookmarkCount: Int
    let sourceBreakdown: [PostAnalyticsSourceBreakdownItem]

    var thumbnailURL: URL? { thumbnailUrl.flatMap(URL.init(string:)) }
}

struct PostAnalyticsSourceBreakdownItem: Equatable, Hashable, Sendable {
    let source: PostViewSourceEnum?
    let viewsCount: Int
}
