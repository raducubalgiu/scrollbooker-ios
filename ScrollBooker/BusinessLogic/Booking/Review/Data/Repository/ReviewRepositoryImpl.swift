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
    
    func createReview(id: Int, request: ReviewCreateRequest) async throws -> Review {
        let dto = try await api.createReview(id: id, request: request)
        return Review(dto: dto)
    }
    
    func updateReview(id: Int, request: ReviewUpdateRequest) async throws -> Review {
        let dto = try await api.updateReview(id: id, request: request)
        return Review(dto: dto)
    }
}
