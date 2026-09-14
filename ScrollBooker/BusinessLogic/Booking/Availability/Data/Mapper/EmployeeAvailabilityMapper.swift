//
//  EmployeeAvailabilityMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

extension EmployeeAvailability {
    init(dto: EmployeeAvailabilityDto) {
        self.employeeId = dto.employeeId
        self.hasAvailability = dto.hasAvailability
    }
}
