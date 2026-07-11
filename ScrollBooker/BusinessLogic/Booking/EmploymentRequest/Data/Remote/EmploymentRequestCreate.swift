//
//  EmploymentRequestCreateRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

struct EmploymentRequestCreate: Encodable {
    let employee_id: Int
    let profession_id: Int
    let consent_id: Int
}
