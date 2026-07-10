//
//  ReviewApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import Foundation

protocol ReviewApiService: Sendable {
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> ReviewDto
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> ReviewDto
}

final class ReviewAPIImpl: ReviewApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
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
