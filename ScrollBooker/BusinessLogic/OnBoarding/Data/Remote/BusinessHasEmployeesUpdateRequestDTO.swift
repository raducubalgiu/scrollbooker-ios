//
//  BusinessHasEmployeesUpdateRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

struct BusinessHasEmployeesUpdateRequestDTO: Encodable {
    let hasEmployees: Bool

    enum CodingKeys: String, CodingKey {
        case hasEmployees = "has_employees"
    }
}
