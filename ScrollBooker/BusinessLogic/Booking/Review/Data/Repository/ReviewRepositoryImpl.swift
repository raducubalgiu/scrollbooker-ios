//
//  ReviewRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

final class ReviewRepositoryImpl: ReviewRepository {
    private let api: ReviewApiService
        
    init(api: ReviewApiService) {
        self.api = api
    }
    
    func getWrittenReviews(userId: Int, page: Int, limit: Int, ratings: [Int]?) async throws -> PaginatedResponse<Review> {
        let dtoResponse = try await api.getWrittenReviews(userId: userId, page: page, limit: limit, ratings: ratings)
        
        return PaginatedResponse(dtoResponse) {
            Review(dto: $0)
        }
            
    }
    
    func getReviewSummary(userId: Int) async throws -> ReviewSummary {
        let dto = try await api.getReviewSummary(userId: userId)
        return ReviewSummary(dto: dto)
    }
    
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> Review {
        let dto = try await api.createReview(id: id, request: request)
        return Review(dto: dto)
    }
    
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> Review {
        let dto = try await api.updateReview(id: id, request: request)
        return Review(dto: dto)
    }
}
