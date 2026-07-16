//
//  BusinessDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BusinessDto: Decodable {
    let id: Int
    let business_type_id: Int
    let owner_id: Int
    let description: String?
    let timezone: String
    let address: String
    let formatted_address: String
    let coordinates: BusinessCoordinatesDto
    let city: String
    let country_code: String
    let map_url: String
    let services: [ServiceDto]
    let schedules: [ScheduleDto]
    let has_employees: Bool        
}
