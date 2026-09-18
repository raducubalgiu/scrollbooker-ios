//
//  PostAnalyticsSummary.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

struct PostAnalyticsSummary: Equatable, Hashable, Sendable {
    let postId: Int
    let viewsCount: Int
    let uniqueViewersCount: Int
    let watchTimeMs: Int
    let averageWatchTimeMs: Int
    let completionsCount: Int
    let sourceBreakdown: [PostAnalyticsSourceBreakdownItem]
}

struct PostAnalyticsSourceBreakdownItem: Equatable, Hashable, Sendable {
    let source: PostViewSourceEnum?
    let viewsCount: Int
}
