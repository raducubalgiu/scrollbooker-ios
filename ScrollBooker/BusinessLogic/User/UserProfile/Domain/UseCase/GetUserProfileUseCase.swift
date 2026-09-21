//
//  GetUseProfileUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 07.07.2026.
//

import Foundation

final class GetUserProfileUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(username: String, lat: Double? = nil, lng: Double? = nil) async throws -> UserProfile {
        try await repository.getUserProfile(username: username, lat: lat, lng: lng)
    }
}
