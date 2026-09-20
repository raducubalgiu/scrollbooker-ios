//
//  ReviewApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

protocol ReviewApiService: Sendable {
    func getWrittenReviews(businessId: Int, employeeId: Int?, page: Int, limit: Int, ratings: [Int]?) async throws -> PaginatedResponseDTO<ReviewDto>
    func getReviewSummary(businessId: Int, employeeId: Int?) async throws -> ReviewSummaryDto
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewMutationResponseDto
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewMutationResponseDto
    func likeReview(id: Int) async throws -> NoContent
    func unlikeReview(id: Int) async throws -> NoContent
    func deleteReview(id: Int) async throws -> NoContent
}

final class ReviewAPIImpl: ReviewApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getWrittenReviews(
        businessId: Int,
        employeeId: Int?,
        page: Int,
        limit: Int,
        ratings: [Int]?
    ) async throws -> PaginatedResponseDTO<ReviewDto> {

        var query: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]

        if let employeeId {
            query["employee_id"] = "\(employeeId)"
        }

        if let ratings = ratings {
            for (index, rating) in ratings.enumerated() {
                let invisiblePadding = String(repeating: "\u{200B}", count: index)
                let uniqueKey = "ratings" + invisiblePadding

                query[uniqueKey] = "\(rating)"
            }
        }

        return try await client.request(
            "businesses/\(businessId)/reviews",
            method: .get,
            query: query
        )
    }

    func getReviewSummary(businessId: Int, employeeId: Int?) async throws -> ReviewSummaryDto {
        var query: [String: String] = [:]

        if let employeeId {
            query["employee_id"] = "\(employeeId)"
        }

        return try await client.request(
            "businesses/\(businessId)/reviews-summary",
            method: .get,
            query: query
        )
    }


    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewMutationResponseDto {
        return try await client.request(
            "appointments/\(id)/create-review",
            method: .post,
            body: request
        )
    }

    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewMutationResponseDto {
        return try await client.request(
            "reviews/\(id)",
            method: .put,
            body: request
        )
    }

    func likeReview(id: Int) async throws -> NoContent {
        return try await client.request(
            "reviews/\(id)/likes",
            method: .post
        )
    }

    func unlikeReview(id: Int) async throws -> NoContent {
        return try await client.request(
            "reviews/\(id)/likes",
            method: .delete
        )
    }

    func deleteReview(id: Int) async throws -> NoContent {
        return try await client.request(
            "reviews/\(id)",
            method: .delete
        )
    }
}
