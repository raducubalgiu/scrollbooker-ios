//
//  UpdateUserBirthdateUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

final class UpdateUserBirthdateUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(birthdate: String?) async throws -> UserProfileUpdate {
        let request = UpdateBirthDateRequest(birthdate: birthdate)
        
        return try await repository.updateBirthdate(request: request)
    }
}
