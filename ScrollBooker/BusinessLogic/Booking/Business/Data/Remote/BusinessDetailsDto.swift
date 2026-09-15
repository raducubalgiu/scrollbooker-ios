//
//  BusinessDetailsDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessDetailsDto: Decodable {
    let id: Int
    let owner: BusinessOwnerDto
    let location: BusinessLocationDto
    let hasEmployees: Bool
    let mediaFiles: [BusinessMediaFileDto]
    let schedules: [ScheduleDto]

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case location
        case hasEmployees = "has_employees"
        case mediaFiles = "media_files"
        case schedules
    }
}
