//
//  DashboardRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class DashboardRepositoryImpl: DashboardRepository {
    private let api: DashboardApiService

    init(api: DashboardApiService) {
        self.api = api
    }

    func getDashboardBooking(
        startDate: String,
        endDate: String
    ) async throws -> DashboardBooking {
        let dtoResponse = try await api.getDashboardBooking(
            startDate: startDate,
            endDate: endDate
        )

        return DashboardBooking(dto: dtoResponse)
    }
}
