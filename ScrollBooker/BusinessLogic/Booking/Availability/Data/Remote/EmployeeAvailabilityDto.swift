//
//  EmployeeAvailabilityDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct EmployeeAvailabilityDto: Decodable {
    let employeeId: Int
    let hasAvailability: Bool

    enum CodingKeys: String, CodingKey {
        case employeeId = "employee_id"
        case hasAvailability = "has_availability"
    }
}
