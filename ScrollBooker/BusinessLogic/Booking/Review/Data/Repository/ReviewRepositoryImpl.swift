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

    func getWrittenReviews(
        businessId: Int,
        employeeId: Int?,
        page: Int,
        limit: Int,
        ratings: [Int]?
    ) async throws -> PaginatedResponse<Review> {
        let dtoResponse = try await api.getWrittenReviews(businessId: businessId, employeeId: employeeId, page: page, limit: limit, ratings: ratings)

        return PaginatedResponse(dtoResponse) {
            Review(dto: $0)
        }

    }

    func getReviewSummary(businessId: Int, employeeId: Int?) async throws -> ReviewSummary {
        let dto = try await api.getReviewSummary(businessId: businessId, employeeId: employeeId)
        return ReviewSummary(dto: dto)
    }

    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewMutationResult {
        let dto = try await api.createReview(id: id, request: request)
        return ReviewMutationResult(dto: dto)
    }

    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewMutationResult {
        let dto = try await api.updateReview(id: id, request: request)
        return ReviewMutationResult(dto: dto)
    }

    func likeReview(id: Int) async throws -> NoContent {
        return try await api.likeReview(id: id)
    }

    func unlikeReview(id: Int) async throws -> NoContent {
        return try await api.unlikeReview(id: id)
    }

    func deleteReview(id: Int) async throws -> NoContent {
        return try await api.deleteReview(id: id)
    }
}
