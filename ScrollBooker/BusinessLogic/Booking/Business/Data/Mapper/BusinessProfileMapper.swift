//
//  BusinessProfileMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

extension BusinessProfile {
    init(from dto: BusinessProfileDto) {
        self.id = dto.id
        self.owner = BusinessProfileOwner(from: dto.owner)
        self.openingHours = OpeningHours(dto: dto.openingHours)
        self.mediaFiles = dto.mediaFiles.map { BusinessMediaFile(from: $0) }
        self.location = BusinessLocation(from: dto.location)
        self.distanceKm = dto.distanceKm
        self.description = dto.description
        self.employees = dto.employees.map { BusinessProfileEmployee(from: $0) }
        self.schedules = dto.schedules.map { Schedule(dto: $0) }
        self.reviews = BusinessProfileReviews(from: dto.reviews)
        self.posts = dto.posts.map { BusinessProfileLatestPost(from: $0) }
        self.nearbyBusinesses = dto.nearbyBusinesses.map { NearbyBusiness(from: $0) }
        self.userProducts = UserProducts(dto: dto.userProducts)
    }
}

extension BusinessProfileLatestPost {
    init(from dto: BusinessProfileLatestPostDto) {
        self.id = dto.id
        self.businessId = dto.businessId
        self.user = BusinessProfileLatestPostUser(from: dto.user)
        self.viewsCount = dto.viewsCount
        self.mediaFiles = dto.mediaFiles.map { PostMediaFile(from: $0) }
    }
}

extension BusinessProfileLatestPostUser {
    init(from dto: BusinessProfileLatestPostUserDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
    }
}

extension BusinessProfileOwner {
    init(from dto: BusinessProfileOwnerDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.counters = BusinessProfileCounters(from: dto.counters)
        self.isFollow = dto.isFollow
    }
}

extension BusinessLocation {
    init(from dto: BusinessLocationDto) {
        self.address = dto.address
        self.formattedAddress = dto.formattedAddress
        self.coordinates = dto.coordinates
        self.mapUrl = dto.mapUrl
    }
}

extension BusinessProfileCounters {
    init(from dto: BusinessProfileCountersDto) {
        self.followersCount = dto.followersCount
        self.followingsCount = dto.followingsCount
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
    }
}

extension BusinessProfileEmployee {
    init(from dto: BusinessProfileEmployeeDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.ratingsAverage = dto.ratingsAverage
    }
}

extension BusinessProfileReviews {
    init(from dto: BusinessProfileReviewsDto) {
        self.total = dto.total
        self.data = dto.data.map { BusinessProfileReview(from: $0) }
    }
}

extension BusinessProfileReview {
    init(from dto: BusinessProfileReviewDto) {
        self.id = dto.id
        self.review = dto.review
        self.rating = dto.rating
        self.reviewer = BusinessProfileReviewer(from: dto.reviewer)
        self.createdAt = dto.createdAt
    }
}

extension BusinessProfileReviewer {
    init(from dto: BusinessProfileReviewerDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
    }
}

extension NearbyBusinessOwner {
    init(from dto: NearbyBusinessOwnerDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.counters = BusinessProfileCounters(from: dto.counters)
    }
}

extension NearbyBusiness {
    init(from dto: NearbyBusinessDto) {
        self.id = dto.id
        self.owner = NearbyBusinessOwner(from: dto.owner)
        self.mediaFiles = dto.mediaFiles.map { BusinessMediaFile(from: $0) }
        self.location = BusinessLocation(from: dto.location)
        self.distanceKm = dto.distanceKm
    }
}

extension BusinessMediaFile {
    init(from dto: BusinessMediaFileDto) {
        self.url = dto.url
        self.urlKey = dto.urlKey
        self.thumbnailUrl = dto.thumbnailUrl
        self.thumbnailKey = dto.thumbnailKey
        self.type = dto.type
        self.orderIndex = dto.orderIndex
    }
}
