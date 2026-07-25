//
//  ReviewSummaryDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ReviewSummaryDto: Decodable {
    let ratingsAverage: Float
    let ratingsCount: Int
    let breakdown: [RatingBreakdownDto]
    
    enum CodingKeys: String, CodingKey {
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case breakdown
    }
}

struct RatingBreakdownDto: Decodable {
    let rating: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case rating
        case count
    }
}
