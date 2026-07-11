//
//  UpdateSchedulesUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class UpdateSchedulesUseCase {
    private let repository: ScheduleRepository

    init(repository: ScheduleRepository) {
        self.repository = repository
    }

    func callAsFunction(schedules: [Schedule]) async throws -> [Schedule] {
        let schedulesDto = schedules.toDto()
        
        return try await repository.updateSchedules(schedules: schedulesDto)
    }
}
