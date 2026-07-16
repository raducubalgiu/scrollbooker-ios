//
//  BusinessOwnerMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

extension BusinessOwner {
    init(dto: BusinessOwnerDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
    }
}
