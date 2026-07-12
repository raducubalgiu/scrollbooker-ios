//
//  UpdateUserGenderUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

final class UpdateUserGenderUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(gender: String) async throws -> UserProfileUpdate {
        let request = UpdateGenderRequest(gender: gender)
        
        return try await repository.updateGender(request: request)
    }
}
