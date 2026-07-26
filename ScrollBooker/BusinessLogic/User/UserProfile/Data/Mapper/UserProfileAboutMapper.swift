//
//  UserProfileAboutMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

extension UserProfileAbout {
    init(dto: UserProfileAboutDto) {
        self.description = dto.description
        self.schedules = dto.schedules.map { Schedule(dto: $0) }
        self.location = BusinessLocation(from: dto.location)
        self.owner = UserProfileAboutOwner(dto: dto.owner)
        self.businessMedia = dto.businessMedia.map { BusinessMediaFile(dto: $0) }
    }
}

extension UserProfileAboutOwner {
    init(dto: UserProfileAboutOwnnerDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.ratingsAverage = dto.ratingsAverage
    }
}

