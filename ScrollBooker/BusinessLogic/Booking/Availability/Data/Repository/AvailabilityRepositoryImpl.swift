//
//  AvailabilityRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

final class AvailabilityRepositoryImpl: AvailabilityRepository {
    private let api: AvailabilityApiService

    init(api: AvailabilityApiService) {
        self.api = api
    }

    func getUserCalendarAvailableDays(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> [String] {
        return try await api.getUserCalendarAvailableDays(
            businessId: businessId,
            employeeId: employeeId,
            startDate: startDate,
            endDate: endDate,
            slotDuration: slotDuration
        )
    }

    func getUserAvailableTimeSlots(
        businessId: Int,
        employeeId: Int?,
        slotDuration: Int,
        day: String
    ) async throws -> AvailableDay {
        let dtoResponse = try await api.getUserAvailableTimeSlots(
            businessId: businessId,
            employeeId: employeeId,
            slotDuration: slotDuration,
            day: day
        )

        return AvailableDay(dto: dtoResponse)
    }

    func getUserCalendarEvents(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> CalendarEvents {
        let dtoResponse = try await api.getUserCalendarEvents(
            businessId: businessId,
            employeeId: employeeId,
            startDate: startDate,
            endDate: endDate,
            slotDuration: slotDuration
        )

        return CalendarEvents(dto: dtoResponse)
    }

    func getBusinessEmployeesCalendarEventsByDay(
        day: String,
        slotDuration: Int
    ) async throws -> CalendarEventsBusinessDay {
        let dtoResponse = try await api.getBusinessEmployeesCalendarEventsByDay(
            day: day,
            slotDuration: slotDuration
        )

        return CalendarEventsBusinessDay(dto: dtoResponse)
    }

    func getEmployeesAvailabilityForDay(
        day: String,
        slotDuration: Int
    ) async throws -> [EmployeeAvailability] {
        return try await api.getEmployeesAvailabilityForDay(
            day: day,
            slotDuration: slotDuration
        ).map { EmployeeAvailability(dto: $0) }
    }
}
