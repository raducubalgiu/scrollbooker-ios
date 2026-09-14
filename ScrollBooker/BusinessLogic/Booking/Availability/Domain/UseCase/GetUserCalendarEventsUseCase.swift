//
//  GetUserCalendarEventsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class GetUserCalendarEventsUseCase {
    private let repository: AvailabilityRepository

    init(repository: AvailabilityRepository) {
        self.repository = repository
    }

    func callAsFunction(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> CalendarEvents {
        try await repository.getUserCalendarEvents(
            businessId: businessId,
            employeeId: employeeId,
            startDate: startDate,
            endDate: endDate,
            slotDuration: slotDuration
        )
    }
}
