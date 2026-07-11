//
//  ConsentApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

protocol ConsentApiService: Sendable {
    func getConsentByName(consentName: ConsentEnum) async throws -> ConsentDto
}

final class ConsentAPIImpl: ConsentApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getConsentByName(consentName: ConsentEnum) async throws -> ConsentDto {
        return try await client.request(
            "consents/\(consentName.rawValue)",
            method: .get
        )
    }
}
