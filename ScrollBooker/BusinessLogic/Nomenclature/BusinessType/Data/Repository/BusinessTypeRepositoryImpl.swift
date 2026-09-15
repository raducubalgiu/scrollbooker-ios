//
//  BusinessTypeRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class BusinessTypeRepositoryImpl: BusinessTypeRepository {
    private let api: BusinessTypeApiService

    init(api: BusinessTypeApiService) {
        self.api = api
    }

    func getAllPaginatedBusinessTypes(page: Int, limit: Int) async throws -> PaginatedResponse<BusinessType> {
        let dtoResponse = try await api.getAllPaginatedBusinessTypes(page: page, limit: limit)
        return PaginatedResponse(dtoResponse) { BusinessType(dto: $0) }
    }
}
