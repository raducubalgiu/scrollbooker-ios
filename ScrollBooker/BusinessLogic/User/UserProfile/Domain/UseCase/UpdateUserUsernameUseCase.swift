//
//  UpdateUserUsernameUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

final class UpdateUserUsernameUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(username: String) async throws -> UserProfileUpdate {
        let request = UpdateUsernameRequest(username: username)
        
        return try await repository.updateUsername(request: request)
    }
}
