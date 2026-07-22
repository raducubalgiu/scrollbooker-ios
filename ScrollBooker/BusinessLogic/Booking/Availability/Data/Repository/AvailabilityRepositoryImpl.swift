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
        endDate: String
    ) async throws -> [String] {
        return try await api.getUserCalendarAvailableDays(
            businessId: businessId,
            employeeId: employeeId,
            startDate: startDate,
            endDate: endDate
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
}
