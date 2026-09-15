//
//  BusinessTypeApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

protocol BusinessTypeApiService: Sendable {
    func getAllPaginatedBusinessTypes(page: Int, limit: Int) async throws -> PaginatedResponseDTO<BusinessTypeDto>
}

final class BusinessTypeAPIImpl: BusinessTypeApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getAllPaginatedBusinessTypes(page: Int, limit: Int) async throws -> PaginatedResponseDTO<BusinessTypeDto> {
        try await client.request(
            "business-types",
            method: .get,
            query: ["page": "\(page)", "limit": "\(limit)"]
        )
    }
}
