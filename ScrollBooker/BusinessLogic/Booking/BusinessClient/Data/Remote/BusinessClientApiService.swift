//
//  BusinessClientApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

protocol BusinessClientApiService: Sendable {
    func getBusinessClients(businessId: Int, query: String?, page: Int, limit: Int) async throws -> PaginatedResponseDTO<BusinessClientDTO>
    func createBusinessClient(businessId: Int, request: BusinessClientCreateRequestDTO) async throws -> BusinessClientDTO
}

final class BusinessClientAPIImpl: BusinessClientApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getBusinessClients(businessId: Int, query: String?, page: Int, limit: Int) async throws -> PaginatedResponseDTO<BusinessClientDTO> {
        var queryItems: [String: String] = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        if let query, !query.isEmpty {
            queryItems["query"] = query
        }

        return try await client.request(
            "businesses/\(businessId)/clients",
            method: .get,
            query: queryItems
        )
    }

    func createBusinessClient(businessId: Int, request: BusinessClientCreateRequestDTO) async throws -> BusinessClientDTO {
        return try await client.request(
            "businesses/\(businessId)/clients",
            method: .post,
            body: request
        )
    }
}
