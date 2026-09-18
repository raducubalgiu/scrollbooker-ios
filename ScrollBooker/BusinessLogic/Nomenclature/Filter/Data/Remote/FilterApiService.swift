//
//  FilterApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

protocol FilterApiService: Sendable {
    func getFiltersByService(serviceId: Int) async throws -> [FilterDto]
}

final class FilterAPIImpl: FilterApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getFiltersByService(serviceId: Int) async throws -> [FilterDto] {
        try await client.request(
            "services/\(serviceId)/filters",
            method: .get
        )
    }
}
