//
//  EmployeeMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

extension Employee {
    init(dto: EmployeeDto) throws {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.avatar = dto.avatar
        self.job = dto.job
        self.hireDate = dto.hireDate
        self.ratingsAverage = dto.ratingsAverage
        self.followersCount = dto.followersCount
        self.ratingsCount = dto.ratingsCount
        self.productsCount = dto.productsCount
    }
}
