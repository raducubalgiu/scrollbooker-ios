//
//  BusinessClientRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

final class BusinessClientRepositoryImpl: BusinessClientRepository {
    private let api: BusinessClientApiService

    init(api: BusinessClientApiService) {
        self.api = api
    }

    func getBusinessClients(businessId: Int, query: String?, page: Int, limit: Int) async throws -> PaginatedResponse<BusinessClient> {
        let dto = try await api.getBusinessClients(businessId: businessId, query: query, page: page, limit: limit)
        return PaginatedResponse(dto) { $0.toDomain() }
    }

    func createBusinessClient(businessId: Int, fullname: String, phone: String?) async throws -> BusinessClient {
        let dto = try await api.createBusinessClient(
            businessId: businessId,
            request: BusinessClientCreateRequestDTO(fullname: fullname, phone: phone)
        )
        return dto.toDomain()
    }
}
