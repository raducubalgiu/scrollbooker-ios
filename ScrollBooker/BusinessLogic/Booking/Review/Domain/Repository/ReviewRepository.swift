//
//  ReviewRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

protocol ReviewRepository: Sendable {
    func getWrittenReviews(businessId: Int, employeeId: Int?, page: Int, limit: Int, ratings: [Int]?) async throws -> PaginatedResponse<Review>
    func getReviewSummary(businessId: Int, employeeId: Int?) async throws -> ReviewSummary
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewMutationResult
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewMutationResult
    func likeReview(id: Int) async throws -> NoContent
    func unlikeReview(id: Int) async throws -> NoContent
    func deleteReview(id: Int) async throws -> NoContent
}
