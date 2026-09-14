//
//  GetUnapprovedBusinessesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class GetUnapprovedBusinessesUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(
        page: Int,
        limit: Int
    ) async throws -> PaginatedResponse<UnapprovedBusiness> {
        try await repository.getUnapprovedBusinesses(page: page, limit: limit)
    }
}
