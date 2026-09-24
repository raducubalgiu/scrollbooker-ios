//
//  UserProfileApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

protocol UserProfileApiService: Sendable {
    func getUserProfile(username: String, lat: Double?, lng: Double?) async throws -> UserProfileDTO
    func getUserProfileAbout(userId: Int) async throws -> UserProfileAboutDto
    func updateFullName(request: UpdateFullNameRequest) async throws -> UserProfileUpdateDto
    func updateUsername(request: UpdateUsernameRequest) async throws -> UserProfileUpdateDto
    func updateBirthdate(request: UpdateBirthDateRequest) async throws -> UserProfileUpdateDto
    func updateGender(request: UpdateGenderRequest) async throws -> UserProfileUpdateDto
    func updateBio(request: UpdateBioRequest) async throws -> UserProfileUpdateDto
    func updateWebsite(request: UpdateWebsiteRequest) async throws -> UserProfileUpdateDto
    func updatePublicEmail(request: UpdatePublicEmailRequest) async throws -> UserProfileUpdateDto
    func updateAvatar(photo: Data) async throws -> UpdateAvatarResponseDto
    func searchUsername(username: String) async throws -> SearchUsernameDTO
    func shareUserProfile(userId: Int, request: ShareRequest) async throws -> NoContent
}

final class UserProfileApiImpl: UserProfileApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getUserProfile(username: String, lat: Double?, lng: Double?) async throws -> UserProfileDTO {
        var query: [String: String] = [:]
        if let lat, let lng {
            query["lat"] = "\(lat)"
            query["lng"] = "\(lng)"
        }

        return try await client.request(
            "users/\(username)/user-profile",
            method: .get,
            query: query
        )
    }
    
    func getUserProfileAbout(userId: Int) async throws -> UserProfileAboutDto {
        try await client.request(
            "users/\(userId)/about",
            method: .get
        )
    }
    
    func updateFullName(request: UpdateFullNameRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/fullname",
            method: .patch,
            body: request
        )
    }
    
    func updateUsername(request: UpdateUsernameRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/username",
            method: .patch,
            body: request
        )
    }
    
    func updateBirthdate(request: UpdateBirthDateRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/birthdate",
            method: .patch,
            body: request
        )
    }
    
    func updateGender(request: UpdateGenderRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/gender",
            method: .patch,
            body: request
        )
    }
    
    func updateBio(request: UpdateBioRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/bio",
            method: .patch,
            body: request
        )
    }
    
    func updateWebsite(request: UpdateWebsiteRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/website",
            method: .patch,
            body: request
        )
    }
    
    func updatePublicEmail(request: UpdatePublicEmailRequest) async throws -> UserProfileUpdateDto {
        try await client.request(
            "users/user-info/public-email",
            method: .patch,
            body: request
        )
    }

    func updateAvatar(photo: Data) async throws -> UpdateAvatarResponseDto {
        try await client.multiPartRequest(
            "users/user-info/avatar",
            method: .patch,
            fields: [:],
            files: MultipartFile.compressedJPEGs([photo], fieldName: "avatar", maxDimension: 640)
        )
    }

    func searchUsername(username: String) async throws -> SearchUsernameDTO {
        try await client.request(
            "users/available-username",
            method: .get,
            query: ["username": username]
        )
    }

    func shareUserProfile(userId: Int, request: ShareRequest) async throws -> NoContent {
        try await client.request(
            "users/\(userId)/share-profile",
            method: .post,
            body: request
        )
    }
}

