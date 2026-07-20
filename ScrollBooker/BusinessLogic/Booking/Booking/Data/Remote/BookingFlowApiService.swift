//
//  BookingFlowApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

protocol BookingFlowApiService: Sendable {
    func getBookingFlow(businessId: Int, employeeId: Int?) async throws -> BookingFlowDto
}

final class BookingFlowAPIImpl: BookingFlowApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getBookingFlow(businessId: Int, employeeId: Int?) async throws -> BookingFlowDto {
        var queryParams: [String: String] = [:]
        
        if let employeeId = employeeId {
            queryParams["employee_id"] = String(employeeId)
        }
        
        return try await client.request(
            "businesses/\(businessId)/booking",
            method: .get,
            query: queryParams.isEmpty ? nil : queryParams
        )
    }
}

