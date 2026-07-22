//
//  GetUserAvailableDaysUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

final class GetUserAvailableDaysUseCase {
    private let repository: AvailabilityRepository

    init(repository: AvailabilityRepository) {
        self.repository = repository
    }

    func callAsFunction(
        businessId: Int,
        employeeId: Int?,
        startDate: String,
        endDate: String
    ) async throws -> [String] {
        try await repository.getUserCalendarAvailableDays(
            businessId: businessId,
            employeeId: employeeId,
            startDate: startDate,
            endDate: endDate
        )
    }
}
