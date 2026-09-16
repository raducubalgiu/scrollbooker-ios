//
//  UpdateUserAvatarUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

final class UpdateUserAvatarUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(photo: Data) async throws -> String {
        try await repository.updateAvatar(photo: photo)
    }
}
