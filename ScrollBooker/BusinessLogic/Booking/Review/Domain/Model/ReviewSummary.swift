//
//  ReviewSummary.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ReviewSummary: Equatable, Hashable, Sendable {
    let ratingsAverage: Float
    let ratingsCount: Int
    let breakdown: [RatingBreakdown]
}

struct RatingBreakdown: Equatable, Hashable, Sendable {
    let rating: Int
    let count: Int
}
