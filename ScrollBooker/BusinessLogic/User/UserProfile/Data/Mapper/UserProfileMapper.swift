//
//  UserProfileMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import Foundation

extension UserProfile {
    init(dto: UserProfileDTO) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullname
        self.avatar = dto.avatar
        self.gender = dto.gender
        self.dateOfBirth = dto.dateOfBirth
        self.bio = dto.bio
        self.website = dto.website
        self.publicEmail = dto.publicEmail
        self.instagram = dto.instagram
        self.tiktok = dto.tiktok
        self.businessId = dto.businessId
        self.businessTypeId = dto.businessTypeId
        self.counters = UserCounters(dto: dto.counters)
        self.profession = dto.profession
        self.openingHours = OpeningHours(dto: dto.openingHours)
        self.isFollow = dto.isFollow
        self.businessOwner = dto.businessOwner.map { ProfileBusinessOwner(dto: $0) }
        self.isOwnProfile = dto.isOwnProfile
        self.isBusinessOrEmployee = dto.isBusinessOrEmployee
        self.distanceKm = dto.distanceKm
        self.address = dto.address
    }
}

extension ProfileBusinessOwner {
    init(dto: ProfileBusinessOwnerDTO) {
        self.id = dto.id
        self.fullName = dto.fullname
        self.username = dto.username
        self.avatar = dto.avatar
    }
}

extension UserCounters {
    init(dto: UserCountersDTO) {
        self.userId = dto.userId
        self.followingsCount = dto.followingsCount
        self.followersCount = dto.followersCount
        self.productsCount = dto.productsCount
        self.postsCount = dto.postsCount
        self.ratingsCount = dto.ratingsCount
        self.ratingsAverage = dto.ratingsAverage
    }
}

extension OpeningHours {
    init(dto: OpeningHoursDTO) {
        self.openNow = dto.openNow
        self.closingTime = dto.closingTime
        self.nextOpenDay = dto.nextOpenDay
        self.nextOpenTime = dto.nextOpenTime
    }
}

