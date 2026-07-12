//
//  UpdateUserFullNameUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

final class UpdateUserFullNameUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(fullname: String) async throws -> UserProfileUpdate {
        let request = UpdateFullNameRequest(fullname: fullname)
        
        return try await repository.updateFullName(request: request)
    }
}
