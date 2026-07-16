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
        self.dateOfBirth = dto.date_of_birth
        self.bio = dto.bio
        self.website = dto.website
        self.publicEmail = dto.public_email
        self.instagram = dto.instagram
        self.tiktok = dto.tiktok
        self.businessId = dto.business_id
        self.businessTypeId = dto.business_type_id
        self.counters = UserCounters(dto: dto.counters)
        self.profession = dto.profession
        self.openingHours = OpeningHours(dto: dto.opening_hours)
        self.isFollow = dto.is_follow
        self.businessOwner = dto.business_owner.map { ProfileBusinessOwner(dto: $0) }
        self.isOwnProfile = dto.is_own_profile
        self.isBusinessOrEmployee = dto.is_business_or_employee
        self.distanceKm = dto.distance_km
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
        self.userId = dto.user_id
        self.followingsCount = dto.followings_count
        self.followersCount = dto.followers_count
        self.productsCount = dto.products_count
        self.postsCount = dto.posts_count
        self.ratingsCount = dto.ratings_count
        self.ratingsAverage = dto.ratings_average
    }
}

extension OpeningHours {
    init(dto: OpeningHoursDTO) {
        self.openNow = dto.open_now
        self.closingTime = dto.closing_time
        self.nextOpenDay = dto.next_open_day
        self.nextOpenTime = dto.next_open_time
    }
}

