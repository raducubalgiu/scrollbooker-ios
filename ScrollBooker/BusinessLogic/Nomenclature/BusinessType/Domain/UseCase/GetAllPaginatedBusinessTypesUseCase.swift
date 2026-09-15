//
//  GetAllPaginatedBusinessTypesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class GetAllPaginatedBusinessTypesUseCase {
    private let repository: BusinessTypeRepository

    init(repository: BusinessTypeRepository) {
        self.repository = repository
    }

    func callAsFunction(page: Int, limit: Int) async throws -> PaginatedResponse<BusinessType> {
        try await repository.getAllPaginatedBusinessTypes(page: page, limit: limit)
    }
}
