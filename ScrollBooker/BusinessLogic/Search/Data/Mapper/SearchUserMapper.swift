//
//  SearchUserMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension SearchUser {
    init(dto: SearchUserDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullname
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.ratingsAverage = Double(dto.ratings_average)
        self.isBusinessOrEmployee = dto.is_business_or_employee
    }
}
