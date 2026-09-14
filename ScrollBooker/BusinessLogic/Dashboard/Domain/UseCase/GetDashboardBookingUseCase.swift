//
//  GetDashboardBookingUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class GetDashboardBookingUseCase {
    private let repository: DashboardRepository

    init(repository: DashboardRepository) {
        self.repository = repository
    }

    func callAsFunction(
        startDate: String,
        endDate: String
    ) async throws -> DashboardBooking {
        try await repository.getDashboardBooking(
            startDate: startDate,
            endDate: endDate
        )
    }
}
