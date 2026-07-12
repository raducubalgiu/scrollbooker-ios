//
//  UpdateUserBioUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

final class UpdateUserBioUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(bio: String) async throws -> UserProfileUpdate {
        let request = UpdateBioRequest(bio: bio)
        
        return try await repository.updateBio(request: request)
    }
}
