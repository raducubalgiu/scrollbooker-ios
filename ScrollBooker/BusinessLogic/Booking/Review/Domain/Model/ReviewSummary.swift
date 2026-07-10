//
//  ReviewSummary.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ReviewsSummary: Equatable, Hashable, Sendable {
    let ratingsAverage: Double
    let ratingsCount: Int
    let breakdown: [RatingBreakdown]
}

struct RatingBreakdown: Equatable, Hashable, Sendable {
    let rating: Int
    let count: Int
}
