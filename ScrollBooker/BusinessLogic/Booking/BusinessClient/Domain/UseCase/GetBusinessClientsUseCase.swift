//
//  GetBusinessClientsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

final class GetBusinessClientsUseCase {
    private let repository: BusinessClientRepository

    init(repository: BusinessClientRepository) {
        self.repository = repository
    }

    func callAsFunction(businessId: Int, query: String?, page: Int = 1, limit: Int = 20) async throws -> PaginatedResponse<BusinessClient> {
        try await repository.getBusinessClients(businessId: businessId, query: query, page: page, limit: limit)
    }
}
