//
//  GetUserProfileAboutUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

final class GetUserProfileAboutUseCase {
    private let repository: UserProfileRepository

    init(repository: UserProfileRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int) async throws -> UserProfileAbout {
        try await repository.getUserProfileAbout(userId: userId)
    }
}
