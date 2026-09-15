//
//  BusinessTypeRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

protocol BusinessTypeRepository: Sendable {
    func getAllPaginatedBusinessTypes(page: Int, limit: Int) async throws -> PaginatedResponse<BusinessType>
}
