//
//  BusinessRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

final class BusinessRepositoryImpl: BusinessRepository {
    private let api: BusinessApiService
        
    init(api: BusinessApiService) {
        self.api = api
    }
    
    func getBusinessesSheet(request: SearchBusinessRequest) async throws -> PaginatedResponse<BusinessSheet> {
        let dtoResponse = try await api.getBusinessesSheet(request: request)
        
        return PaginatedResponse(dtoResponse) {
            BusinessSheet(dto: $0)
        }
    }
    
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarker] {
        let dtoResponse = try await api.getBusinessesMarkers(request: request)
        
        return dtoResponse.map { dto in
            BusinessMarker(dto: dto)
        }
    }
}
