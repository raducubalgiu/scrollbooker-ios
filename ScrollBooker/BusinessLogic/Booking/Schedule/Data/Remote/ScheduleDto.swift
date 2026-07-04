//
//  ScheduleDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ScheduleDto: Codable {
    let id: Int
    let day_of_week: String
    let start_time: String?
    let end_time: String?
}
