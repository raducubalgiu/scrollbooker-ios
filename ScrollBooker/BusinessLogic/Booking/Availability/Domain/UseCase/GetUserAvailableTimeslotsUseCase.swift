//
//  GetUserAvailableTimeslotsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

final class GetUserAvailableTimeslotsUseCase {
    private let repository: AvailabilityRepository

    init(repository: AvailabilityRepository) {
        self.repository = repository
    }

    func callAsFunction(
        businessId: Int,
        employeeId: Int?,
        slotDuration: Int,
        day: String
    ) async throws -> AvailableDay {
        try await repository.getUserAvailableTimeSlots(
            businessId: businessId,
            employeeId: employeeId,
            slotDuration: slotDuration,
            day: day
        )
    }
}
