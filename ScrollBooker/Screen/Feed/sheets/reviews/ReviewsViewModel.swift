//
//  ReviewsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ReviewsViewModel {
    private let userId: Int
    private let getWrittenReviewsUseCase: GetWrittenReviewsUseCase
    private let getReviewSummaryUseCase: GetReviewSummaryUseCase
    private let getVideoReviewsUseCase: GetVideoReviewsUseCase
    
    init(
        userId: Int,
        getWrittenReviewsUseCase: GetWrittenReviewsUseCase,
        getReviewSummaryUseCase: GetReviewSummaryUseCase,
        getVideoReviewsUseCase: GetVideoReviewsUseCase
    ) {
        self.userId = userId
        self.getWrittenReviewsUseCase = getWrittenReviewsUseCase
        self.getReviewSummaryUseCase = getReviewSummaryUseCase
        self.getVideoReviewsUseCase = getVideoReviewsUseCase
    }
}
