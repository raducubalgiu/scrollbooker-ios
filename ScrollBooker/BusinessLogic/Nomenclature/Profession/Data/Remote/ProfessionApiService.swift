//
//  ProfessionApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

protocol ProfessionApiService: Sendable {
    func getProfessionsBybusinessType(businessTypeId: Int) async throws -> [ProfessionDto]
}

final class ProfessionAPIImpl: ProfessionApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getProfessionsBybusinessType(businessTypeId: Int) async throws -> [ProfessionDto] {
        return try await client.request(
            "business-types/\(businessTypeId)/professions",
            method: .get
        )
    }
}
