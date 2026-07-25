//
//  ReviewModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

@MainActor
final class ReviewModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ReviewApiService = {
        ReviewAPIImpl(client: apiClient)
    }()

    private lazy var repository: ReviewRepository = {
        ReviewRepositoryImpl(api: apiService)
    }()
    
    lazy var getWrittenReviewsUseCase: GetWrittenReviewsUseCase = {
        GetWrittenReviewsUseCase(repository: repository)
    }()
    
    lazy var getReviewSummaryUseCase: GetReviewSummaryUseCase = {
        GetReviewSummaryUseCase(repository: repository)
    }()
    
    lazy var createReviewUseCase: CreateReviewUseCase = {
        CreateReviewUseCase(repository: repository)
    }()
    
    lazy var updateReviewUseCase: UpdateReviewUseCase = {
        UpdateReviewUseCase(repository: repository)
    }()
    
    func makeReviewsViewModel(
        userId: Int,
        getVideoReviewsUseCase: GetVideoReviewsUseCase
    ) -> ReviewsViewModel {
        ReviewsViewModel(
            userId: userId,
            getWrittenReviewsUseCase: getWrittenReviewsUseCase,
            getReviewSummaryUseCase: getReviewSummaryUseCase,
            getVideoReviewsUseCase: getVideoReviewsUseCase
        )
    }
}
