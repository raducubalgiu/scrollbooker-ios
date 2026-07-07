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
}
