//
//  ReviewSummaryMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension ReviewsSummary {
    init(dto: ReviewsSummaryDto) {
        self.ratingsAverage = Double(dto.ratings_average)
        self.ratingsCount = dto.ratings_count
        self.breakdown = dto.breakdown.map { RatingBreakdown(dto: $0) }
    }
}

extension RatingBreakdown {
    init(dto: RatingBreakdownDto) {
        self.rating = dto.rating
        self.count = dto.count
    }
}
