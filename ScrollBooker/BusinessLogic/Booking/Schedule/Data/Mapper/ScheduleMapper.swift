//
//  ScheduleMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Schedule {
    init(dto: ScheduleDto) {
        self.id = dto.id
        self.dayOfWeek = dto.day_of_week
        self.startTime = dto.start_time
        self.endTime = dto.end_time
    }
    
    func toDto() -> ScheduleDto {
        return ScheduleDto(
            id: id,
            day_of_week: dayOfWeek,
            start_time: startTime,
            end_time: endTime
        )
    }
}

extension Array where Element == ScheduleDto {
    func toDomain() -> [Schedule] {
        return self.map { Schedule(dto: $0) }
    }
}

extension Array where Element == Schedule {
    func toDto() -> [ScheduleDto] {
        return self.map { $0.toDto() }
    }
}
