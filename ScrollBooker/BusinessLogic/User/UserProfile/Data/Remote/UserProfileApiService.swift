//
//  UserProfileApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

protocol UserProfileApiService: Sendable {
    func getUserProfile(username: String) async throws -> UserProfileDTO
    func updateFullName(request: UpdateFullNameRequest) async throws -> UserProfileUpdateDto
    func updateUsername(request: UpdateUsernameRequest) async throws -> UserProfileUpdateDto
    func updateBirthdate(request: UpdateBirthDateRequest) async throws -> UserProfileUpdateDto
    func updateGender(request: UpdateGenderRequest) async throws -> UserProfileUpdateDto
    func updateBio(request: UpdateBioRequest) async throws -> UserProfileUpdateDto
    func updateWebsite(request: UpdateWebsiteRequest) async throws -> UserProfileUpdateDto
    func updatePublicEmail(request: UpdatePublicEmailRequest) async throws -> UserProfileUpdateDto
}

final class UserProfileApiImpl: UserProfileApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getUserProfile(username: String) async throws -> UserProfileDTO {
        try await client.request(
            "users/\(username)/user-profile",
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
}

