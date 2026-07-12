//
//  UserProfileRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

protocol UserProfileRepository: Sendable {
    func getUserProfile(username: String) async throws -> UserProfile
    func updateFullName(request: UpdateFullNameRequest) async throws -> UserProfileUpdate
    func updateUsername(request: UpdateUsernameRequest) async throws -> UserProfileUpdate
    func updateBirthdate(request: UpdateBirthDateRequest) async throws -> UserProfileUpdate
    func updateGender(request: UpdateGenderRequest) async throws -> UserProfileUpdate
    func updateBio(request: UpdateBioRequest) async throws -> UserProfileUpdate
    func updateWebsite(request: UpdateWebsiteRequest) async throws -> UserProfileUpdate
    func updatePublicEmail(request: UpdatePublicEmailRequest) async throws -> UserProfileUpdate
}
