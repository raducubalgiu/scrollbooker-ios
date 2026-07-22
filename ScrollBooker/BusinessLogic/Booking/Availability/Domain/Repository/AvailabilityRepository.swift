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
        endDate: String
    ) async throws -> [String]
    
    func getUserAvailableTimeSlots(
        businessId: Int,
        employeeId: Int?,
        slotDuration: Int,
        day: String
    ) async throws -> AvailableDay
}
