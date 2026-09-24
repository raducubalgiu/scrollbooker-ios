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
    
    func getBusinessesSheet(page: Int, limit: Int, request: SearchBusinessRequest) async throws -> PaginatedResponse<BusinessSheet> {
        let dtoResponse = try await api.getBusinessesSheet(
            page: page,
            limit: limit,
            request: request
        )
        
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
    
    func getBusinessProfile(username: String, lat: Double?, lng: Double?) async throws -> BusinessProfile {
        let dtoResponse = try await api.getBusinessProfile(username: username, lat: lat, lng: lng)
        return BusinessProfile(from: dtoResponse)
    }

    func getMyBusinessDetails() async throws -> BusinessDetails {
        let dtoResponse = try await api.getMyBusinessDetails()
        return BusinessDetails(dto: dtoResponse)
    }

    func getUnapprovedBusinesses(page: Int, limit: Int) async throws -> PaginatedResponse<UnapprovedBusiness> {
        let dtoResponse = try await api.getUnapprovedBusinesses(page: page, limit: limit)

        return PaginatedResponse(dtoResponse) {
            UnapprovedBusiness(dto: $0)
        }
    }

    func approveBusiness(userId: Int) async throws -> NoContent {
        return try await api.approveBusiness(userId: userId)
    }

    func searchBusinessAddress(query: String) async throws -> [BusinessAddress] {
        let dtoResponse = try await api.searchBusinessAddress(query: query)
        return dtoResponse.map { BusinessAddress(dto: $0) }
    }

    func updateBusinessGallery(businessId: Int, photos: [Data]) async throws -> NoContent {
        return try await api.updateBusinessGallery(businessId: businessId, photos: photos)
    }

    func shareBusinessProfile(businessId: Int, request: ShareRequest) async throws -> NoContent {
        return try await api.shareBusinessProfile(businessId: businessId, request: request)
    }
}
