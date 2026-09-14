//
//  AvailabilityRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

protocol AvailabilityRepository: Sendable {
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
    ) async throws -> AvailableDay

    func getUserCalendarEvents(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String,
        slotDuration: Int
    ) async throws -> CalendarEvents

    func getBusinessEmployeesCalendarEventsByDay(
        day: String,
        slotDuration: Int
    ) async throws -> CalendarEventsBusinessDay

    func getEmployeesAvailabilityForDay(
        day: String,
        slotDuration: Int
    ) async throws -> [EmployeeAvailability]
}
