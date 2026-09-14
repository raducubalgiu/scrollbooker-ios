//
//  GetEmployeesAvailabilityForDayUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class GetEmployeesAvailabilityForDayUseCase {
    private let repository: AvailabilityRepository

    init(repository: AvailabilityRepository) {
        self.repository = repository
    }

    func callAsFunction(
        day: String,
        slotDuration: Int
    ) async throws -> [EmployeeAvailability] {
        try await repository.getEmployeesAvailabilityForDay(
            day: day,
            slotDuration: slotDuration
        )
    }
}
