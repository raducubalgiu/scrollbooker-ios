//
//  DashboardApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

protocol DashboardApiService: Sendable {
    func getDashboardBooking(
        startDate: String,
        endDate: String
    ) async throws -> DashboardBookingDto
}

final class DashboardAPIImpl: DashboardApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getDashboardBooking(
        startDate: String,
        endDate: String
    ) async throws -> DashboardBookingDto {
        return try await client.request(
            "dashboard/bookings",
            method: .get,
            query: [
                "start_date": startDate,
                "end_date": endDate
            ]
        )
    }
}
