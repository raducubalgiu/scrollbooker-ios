//
//  AvailabilityApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

protocol AvailabilityApiService: Sendable {
    func getUserCalendarAvailableDays(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> [String]

    func getUserAvailableTimeSlots(
        businessId: Int,
        employeeId: Int?,
        slotDuration: Int,
        day: String
    ) async throws -> AvailableDayDto

    func getUserCalendarEvents(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> CalendarEventsDto

    func getBusinessEmployeesCalendarEventsByDay(
        day: String,
        slotDuration: Int
    ) async throws -> CalendarEventsBusinessResponseDto

    func getEmployeesAvailabilityForDay(
        day: String,
        slotDuration: Int
    ) async throws -> [EmployeeAvailabilityDto]
}

final class AvailabilityAPIImpl: AvailabilityApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }


    func getUserCalendarAvailableDays(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> [String] {
        var queryParams: [String: String] = [
            "start_date": startDate,
            "end_date": endDate,
            "slot_duration": String(slotDuration)
        ]

        if let employeeId = employeeId {
            queryParams["employee_id"] = String(employeeId)
        }

        return try await client.request(
            "businesses/\(businessId)/availability",
            method: .get,
            query: queryParams
        )
    }

    func getUserAvailableTimeSlots(
        businessId: Int,
        employeeId: Int?,
        slotDuration: Int,
        day: String
    ) async throws -> AvailableDayDto {
        var queryParams: [String: String] = [
            "slot_duration": String(slotDuration),
            "day": day
        ]

        if let employeeId = employeeId {
            queryParams["employee_id"] = String(employeeId)
        }

        return try await client.request(
            "businesses/\(businessId)/availability/timeslots",
            method: .get,
            query: queryParams
        )
    }

    func getUserCalendarEvents(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> CalendarEventsDto {
        var queryParams: [String: String] = [
            "start_date": startDate,
            "end_date": endDate,
            "slot_duration": String(slotDuration)
        ]

        if let employeeId = employeeId {
            queryParams["employee_id"] = String(employeeId)
        }

        return try await client.request(
            "availability/\(businessId)/calendar-events",
            method: .get,
            query: queryParams
        )
    }

    func getBusinessEmployeesCalendarEventsByDay(
        day: String,
        slotDuration: Int
    ) async throws -> CalendarEventsBusinessResponseDto {
        return try await client.request(
            "availability/calendar-events/business",
            method: .get,
            query: [
                "day": day,
                "slot_duration": String(slotDuration)
            ]
        )
    }

    func getEmployeesAvailabilityForDay(
        day: String,
        slotDuration: Int
    ) async throws -> [EmployeeAvailabilityDto] {
        return try await client.request(
            "availability/employees/day-availability",
            method: .get,
            query: [
                "day": day,
                "slot_duration": String(slotDuration)
            ]
        )
    }
}
