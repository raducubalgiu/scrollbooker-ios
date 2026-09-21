//
//  UpdateSlotDurationUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

final class UpdateSlotDurationUseCase {
    private let repository: UserCalendarSettingsRepository

    init(repository: UserCalendarSettingsRepository) {
        self.repository = repository
    }

    func callAsFunction(minutes: Int) async throws -> UserCalendarSettings {
        try await repository.updateSlotDuration(minutes)
    }
}
