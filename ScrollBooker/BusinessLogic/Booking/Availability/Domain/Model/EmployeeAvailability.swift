//
//  EmployeeAvailability.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct EmployeeAvailability: Identifiable, Equatable, Hashable, Sendable {
    var id: Int { employeeId }

    let employeeId: Int
    let hasAvailability: Bool
}
