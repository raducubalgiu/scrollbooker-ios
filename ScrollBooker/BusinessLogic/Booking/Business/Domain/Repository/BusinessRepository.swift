//
//  BusinessRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

protocol BusinessRepository: Sendable {
    func getBusinessesSheet(request: SearchBusinessRequest) async throws -> PaginatedResponse<BusinessSheet>
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarker]
}
