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
        endDate: String
    ) async throws -> [String]
    
    func getUserAvailableTimeSlots(
        businessId: Int,
        employeeId: Int?,
        slotDuration: Int,
        day: String
    ) async throws -> AvailableDayDto
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
        endDate: String
    ) async throws -> [String] {
        var queryParams: [String: String] = [
            "start_date": startDate,
            "end_date": endDate
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
}
