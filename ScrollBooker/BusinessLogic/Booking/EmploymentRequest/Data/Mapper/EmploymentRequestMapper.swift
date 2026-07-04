//
//  EmploymentRequestMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension EmploymentRequest {
    init(dto: EmploymentRequestDto) throws {
        guard let parsedDate = DateParser.parseISO8601UTC(dto.created_at) else {
            throw MappingError.invalidDate(dto.created_at)
        }
        
        self.id = dto.id
        self.createdAt = parsedDate
        self.status = dto.status
        self.employee = EmploymentRequestUser(dto: dto.employee)
        self.employer = EmploymentRequestUser(dto: dto.employer)
        self.profession = Profession(dto: dto.profession)
    }
}

extension EmploymentRequestUser {
    init(dto: EmploymentRequestUserDto) {
        self.id = dto.id
        self.fullName = dto.fullname
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
    }
}
