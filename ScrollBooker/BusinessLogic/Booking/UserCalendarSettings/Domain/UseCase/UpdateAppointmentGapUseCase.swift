//
//  UpdateAppointmentGapUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

final class UpdateAppointmentGapUseCase {
    private let repository: UserCalendarSettingsRepository

    init(repository: UserCalendarSettingsRepository) {
        self.repository = repository
    }

    func callAsFunction(minutes: Int) async throws -> UserCalendarSettings {
        try await repository.updateAppointmentGap(minutes)
    }
}
