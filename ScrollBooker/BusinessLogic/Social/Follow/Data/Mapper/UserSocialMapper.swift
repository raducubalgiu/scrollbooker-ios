//
//  UserSocialMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

extension UserSocial {
    init(dto: UserSocialDto) throws {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.ratingsAverage = dto.ratingsAverage
        self.isFollow = dto.isFollow
        self.isBusinessOrEmployee = dto.isBusinessOrEmployee
    }
}
