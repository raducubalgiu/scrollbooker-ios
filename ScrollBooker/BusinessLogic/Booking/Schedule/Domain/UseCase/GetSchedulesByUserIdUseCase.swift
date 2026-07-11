//
//  GetSchedulesByUserIdUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class GetSchedulesByUserIdUseCase {
    private let repository: ScheduleRepository

    init(repository: ScheduleRepository) {
        self.repository = repository
    }

    func callAsFunction(userId: Int) async throws -> [Schedule] {
        try await repository.getSchedulesByUserId(userId: userId)
    }
}
