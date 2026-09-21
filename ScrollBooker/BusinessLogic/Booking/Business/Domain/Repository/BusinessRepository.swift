//
//  BusinessRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

protocol BusinessRepository: Sendable {
    func getBusinessesSheet(page: Int, limit: Int, request: SearchBusinessRequest) async throws -> PaginatedResponse<BusinessSheet>
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarker]
    func getBusinessProfile(username: String, lat: Double?, lng: Double?) async throws -> BusinessProfile
    func getMyBusinessDetails() async throws -> BusinessDetails
    func getUnapprovedBusinesses(page: Int, limit: Int) async throws -> PaginatedResponse<UnapprovedBusiness>
    func approveBusiness(userId: Int) async throws -> NoContent
    func searchBusinessAddress(query: String) async throws -> [BusinessAddress]
    func updateBusinessGallery(businessId: Int, photos: [Data]) async throws -> NoContent
}
