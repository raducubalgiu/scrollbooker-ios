//
//  ScheduleRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class ScheduleRepositoryImpl: ScheduleRepository {
    private let api: ScheduleApiService
        
    init(api: ScheduleApiService) {
        self.api = api
    }
    
    func getSchedulesByUserId(userId: Int) async throws -> [Schedule] {
        let dtoResponse = try await api.getSchedulesByUserId(userId: userId)
        
        return dtoResponse.map { dto in
            Schedule(dto: dto)
        }
    }
    
    func updateSchedules(schedules: [ScheduleDto]) async throws -> [Schedule] {
        let dtoResponse = try await api.updateSchedules(schedules: schedules)
        
        return dtoResponse.map { dto in
            Schedule(dto: dto)
        }
    }
}
