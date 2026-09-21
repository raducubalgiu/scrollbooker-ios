//
//  ServicesApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

protocol ServicesApiService: Sendable {
    func getServicesByServiceDomainId(_ serviceDomainId: Int) async throws -> [ServiceWithFiltersDto]
}

final class ServicesAPIImpl: ServicesApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getServicesByServiceDomainId(_ serviceDomainId: Int) async throws -> [ServiceWithFiltersDto] {
        try await client.request(
            "service-domains/\(serviceDomainId)/services",
            method: .get
        )
    }
}
