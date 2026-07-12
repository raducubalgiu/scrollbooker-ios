//
//  UserProfileRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

final class UserProfileRepositoryImpl: UserProfileRepository {
    private let api: UserProfileApiService
        
    init(api: UserProfileApiService) {
        self.api = api
    }
    
    func getUserProfile(username: String) async throws -> UserProfile {
        let dto = try await api.getUserProfile(username: username)
        return UserProfile(dto: dto)
    }
    
    func updateFullName(request: UpdateFullNameRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updateFullName(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
    
    func updateUsername(request: UpdateUsernameRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updateUsername(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
    
    func updateBirthdate(request: UpdateBirthDateRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updateBirthdate(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
    
    func updateGender(request: UpdateGenderRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updateGender(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
    
    func updateBio(request: UpdateBioRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updateBio(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
    
    func updateWebsite(request: UpdateWebsiteRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updateWebsite(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
    
    func updatePublicEmail(request: UpdatePublicEmailRequest) async throws -> UserProfileUpdate {
        let dtoResponse = try await api.updatePublicEmail(request: request)
        return UserProfileUpdate(dto: dtoResponse)
    }
}
