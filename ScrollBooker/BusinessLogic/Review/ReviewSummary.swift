//
//  ReviewSummary.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

struct ReviewSummary: Decodable, Hashable {
    let averageRating: Double
    let totalReviews: Int
    let breakdown: [RatingBreakdown]
}

struct RatingBreakdown: Decodable, Hashable {
    let rating: Int
    let count: Int
}
