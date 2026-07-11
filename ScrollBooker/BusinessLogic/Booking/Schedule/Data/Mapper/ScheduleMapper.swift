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
        self.startTime = dto.start_time.map { String($0.prefix(5)) }
        self.endTime = dto.end_time.map { String($0.prefix(5)) }
    }
    
    func toDto() -> ScheduleDto {
        let formattedStart = startTime.map { $0.count == 5 ? "\($0):00" : $0 }
        let formattedEnd = endTime.map { $0.count == 5 ? "\($0):00" : $0 }
        
        return ScheduleDto(
            id: id,
            day_of_week: dayOfWeek,
            start_time: formattedStart,
            end_time: formattedEnd
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
