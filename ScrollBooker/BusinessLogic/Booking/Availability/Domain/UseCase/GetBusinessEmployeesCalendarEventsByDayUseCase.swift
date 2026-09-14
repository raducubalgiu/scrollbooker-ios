//
//  GetBusinessEmployeesCalendarEventsByDayUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class GetBusinessEmployeesCalendarEventsByDayUseCase {
    private let repository: AvailabilityRepository

    init(repository: AvailabilityRepository) {
        self.repository = repository
    }

    func callAsFunction(
        day: String,
        slotDuration: Int
    ) async throws -> CalendarEventsBusinessDay {
        try await repository.getBusinessEmployeesCalendarEventsByDay(
            day: day,
            slotDuration: slotDuration
        )
    }
}
