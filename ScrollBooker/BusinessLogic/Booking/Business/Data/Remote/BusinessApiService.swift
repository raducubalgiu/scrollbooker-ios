//
//  BusinessApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

protocol BusinessApiService: Sendable {
    func getBusinessesSheet(request: SearchBusinessRequest) async throws -> PaginatedResponseDTO<BusinessSheetDto>
}

final class BusinessAPIImpl: BusinessApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getBusinessesSheet(request: SearchBusinessRequest) async throws -> PaginatedResponseDTO<BusinessSheetDto> {
        return try await client.request(
            "businesses/locations",
            method: .post,
            body: request
        )
    }
}
