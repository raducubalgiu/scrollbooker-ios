//
//  ReviewRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

protocol ReviewRepository: Sendable {
    func getWrittenReviews(userId: Int, page: Int, limit: Int, ratings: [Int]?) async throws -> PaginatedResponse<Review>
    func getReviewSummary(userId: Int) async throws -> ReviewSummary
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> Review
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> Review
}
