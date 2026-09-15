//
//  BusinessApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

protocol BusinessApiService: Sendable {
    func getBusinessesSheet(page: Int, limit: Int, request: SearchBusinessRequest) async throws -> PaginatedResponseDTO<BusinessSheetDto>
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarkerDto]
    func getBusinessProfile(username: String) async throws -> BusinessProfileDto
    func getMyBusinessDetails() async throws -> BusinessDetailsDto
    func getUnapprovedBusinesses(page: Int, limit: Int) async throws -> PaginatedResponseDTO<UnapprovedBusinessDto>
    func approveBusiness(userId: Int) async throws -> NoContent
    func searchBusinessAddress(query: String) async throws -> [BusinessAddressDto]
    func updateBusinessGallery(businessId: Int, photos: [Data]) async throws -> NoContent
}

final class BusinessAPIImpl: BusinessApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getBusinessesSheet(page: Int, limit: Int, request: SearchBusinessRequest) async throws -> PaginatedResponseDTO<BusinessSheetDto> {
            let query: [String: String] = [
                "page": "\(page)",
                "limit": "\(limit)"
            ]
            
            return try await client.request(
                "businesses/locations",
                method: .post,
                query: query,
                body: request
            )
        }
    
    func getBusinessesMarkers(request: SearchBusinessRequest) async throws -> [BusinessMarkerDto] {
        return try await client.request(
            "businesses/markers",
            method: .post,
            body: request,
        )
    }
    
    func getBusinessProfile(username: String) async throws -> BusinessProfileDto {
        return try await client.request(
            "businesses/\(username)/profile",
            method: .get
        )
    }

    func getMyBusinessDetails() async throws -> BusinessDetailsDto {
        return try await client.request(
            "businesses/my-business-details",
            method: .get
        )
    }

    func getUnapprovedBusinesses(page: Int, limit: Int) async throws -> PaginatedResponseDTO<UnapprovedBusinessDto> {
        return try await client.request(
            "businesses/unapproved-businesses",
            method: .get,
            query: [
                "page": "\(page)",
                "limit": "\(limit)"
            ]
        )
    }

    func approveBusiness(userId: Int) async throws -> NoContent {
        return try await client.request(
            "users/\(userId)/approve",
            method: .post
        )
    }

    func searchBusinessAddress(query: String) async throws -> [BusinessAddressDto] {
        return try await client.request(
            "places",
            method: .get,
            query: ["query": query]
        )
    }

    func updateBusinessGallery(businessId: Int, photos: [Data]) async throws -> NoContent {
        return try await client.multiPartRequest(
            "businesses/\(businessId)/gallery",
            method: .patch,
            fields: [:],
            files: MultipartFile.compressedJPEGs(photos)
        )
    }
}
