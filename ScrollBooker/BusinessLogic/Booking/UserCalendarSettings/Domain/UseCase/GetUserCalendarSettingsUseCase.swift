//
//  GetUserCalendarSettingsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

final class GetUserCalendarSettingsUseCase {
    private let repository: UserCalendarSettingsRepository

    init(repository: UserCalendarSettingsRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int) async throws -> UserCalendarSettings {
        try await repository.getCalendarSettings(userId: userId)
    }
}
