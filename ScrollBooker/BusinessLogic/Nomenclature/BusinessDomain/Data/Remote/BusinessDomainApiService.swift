//
//  BusinessDomainApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import Foundation

protocol BusinessDomainApiService: Sendable {
    func getAllBusinessDomains() async throws -> [BusinessDomainDto]
}

final class BusinessDomainAPIImpl: BusinessDomainApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getAllBusinessDomains() async throws -> [BusinessDomainDto] {
        return try await client.request(
            "business-domains",
            method: .get
        )
    }
}
