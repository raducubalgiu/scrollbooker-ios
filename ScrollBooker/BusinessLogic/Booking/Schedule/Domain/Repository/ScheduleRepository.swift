//
//  ScheduleRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

protocol ScheduleRepository: Sendable {
    func getSchedulesByUserId(userId: Int) async throws -> [Schedule]
    func updateSchedules(schedules: [ScheduleDto]) async throws -> [Schedule]
}
