//
//  BusinessApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

protocol BusinessApiService: Sendable {
    func getBusinessesSheet(request: SearchBusinessRequest) async throws -> PaginatedResponseDTO<BusinessSheetDto>
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarkerDto]
}

final class BusinessAPIImpl: BusinessApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getBusinessesSheet(request: SearchBusinessRequest) async throws -> PaginatedResponseDTO<BusinessSheetDto> {
        let query: [String: String] = [
            "page": "\(1)",
            "limit": "\(20)"
        ]
        
        return try await client.request(
            "businesses/locations",
            method: .post,
            query: query,
            body: request,
        )
    }
    
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarkerDto] {
        return try await client.request(
            "businesses/markers",
            method: .post,
            body: request,
        )
    }
}
