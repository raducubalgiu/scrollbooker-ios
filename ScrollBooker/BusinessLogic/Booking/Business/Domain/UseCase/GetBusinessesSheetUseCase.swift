//
//  GetBusinessesSheetUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

final class GetBusinessesSheetUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(page: Int, limit: Int, request: SearchBusinessRequest) async throws -> PaginatedResponse<BusinessSheet> {
        try await repository.getBusinessesSheet(page: page, limit: limit, request: request)
    }
}
