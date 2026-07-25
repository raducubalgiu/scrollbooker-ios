//
//  ReviewApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

protocol ReviewApiService: Sendable {
    func getWrittenReviews(userId: Int, page: Int, limit: Int, ratings: [Int]?) async throws -> PaginatedResponseDTO<ReviewDto>
    func getReviewSummary(userId: Int) async throws -> ReviewSummaryDto
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewDto
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewDto
}

final class ReviewAPIImpl: ReviewApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getWrittenReviews(
        userId: Int,
        page: Int,
        limit: Int,
        ratings: [Int]?
    ) async throws -> PaginatedResponseDTO<ReviewDto> {
        
        var query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        if let ratings = ratings {
            for (index, rating) in ratings.enumerated() {
                let invisiblePadding = String(repeating: "\u{200B}", count: index)
                let uniqueKey = "ratings" + invisiblePadding
                
                query[uniqueKey] = "\(rating)"
            }
        }
        
        return try await client.request(
            "users/\(userId)/reviews",
            method: .get,
            query: query
        )
    }
    
    func getReviewSummary(userId: Int) async throws -> ReviewSummaryDto {
        return try await client.request(
            "users/\(userId)/reviews/summary",
            method: .get
        )
    }
    
    
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewDto {
        return try await client.request(
            "appointments/\(id)/create-review",
            method: .post,
            body: request
        )
    }
    
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewDto {
        return try await client.request(
            "reviews/\(id)",
            method: .put,
            body: request
        )
    }
}
