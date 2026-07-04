//
//  EmploymentRequestDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct EmploymentRequestUserDto: Codable {
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
    let profession: String
}

struct EmploymentRequestDto: Codable {
    let id: Int
    let created_at: String
    let status: String
    let employee: EmploymentRequestUserDto
    let employer: EmploymentRequestUserDto
    let profession: ProfessionDto
}
