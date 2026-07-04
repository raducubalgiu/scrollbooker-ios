//
//  ReviewSummaryDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ReviewsSummaryDto: Codable {
    let ratings_average: Float
    let ratings_count: Int    
    let breakdown: [RatingBreakdownDto]
}

struct RatingBreakdownDto: Codable {
    let rating: Int
    let count: Int
}
