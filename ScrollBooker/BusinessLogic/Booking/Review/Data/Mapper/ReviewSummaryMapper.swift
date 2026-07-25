//
//  ReviewSummaryMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension ReviewSummary {
    init(dto: ReviewSummaryDto) {
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
        self.breakdown = dto.breakdown.map { RatingBreakdown(dto: $0) }
    }
}

extension RatingBreakdown {
    init(dto: RatingBreakdownDto) {
        self.rating = dto.rating
        self.count = dto.count
    }
}
