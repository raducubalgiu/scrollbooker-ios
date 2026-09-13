//
//  PostMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

extension Post {
    init(from dto: PostDto) {
        self.id = dto.id
        self.description = dto.description
        self.user = PostUser(from: dto.user)
        self.businessOwner = PostBusinessOwner(from: dto.businessOwner)
        self.employee = dto.employee.map { PostEmployee(from: $0) }
        self.businessLocation = dto.businessLocation.map { PostBusinessLocation(from: $0) }
        self.counters = PostCounters(from: dto.counters)
        self.userActions = UserPostActions(from: dto.userActions)
        self.mediaFiles = dto.mediaFiles.map { PostMediaFile(from: $0) }
        self.hashtags = dto.hashtags?.map { Hashtag(from: $0) }
        self.isVideoReview = dto.isVideoReview
        self.isOwnPost = dto.isOwnPost
        self.businessId = dto.businessId
        self.review = dto.review.map { PostReview(from: $0) }
        self.serviceDomain = dto.serviceDomain.map { PostServiceDomain(from: $0) }
        self.createdAt = dto.createdAt
    }
}

extension PostUser {
    init(from dto: PostUserDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.isFollow = dto.isFollow
        self.profession = dto.profession
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
    }
}

extension PostBusinessOwner {
    init(from dto: PostBusinessOwnerDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
    }
}

extension PostEmployee {
    init(from dto: PostEmployeeDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
    }
}

extension PostBusinessLocation {
    init(from dto: PostBusinessLocationDto) {
        self.address = dto.address
        self.formattedAddress = dto.formattedAddress
        self.coordinates = BusinessCoordinates(
            lat: Double(dto.coordinates.lat),
            lng: Double(dto.coordinates.lng)
        )
        self.mapUrl = dto.mapUrl
        self.placeId = dto.placeId
    }
}

extension PostReview {
    init(from dto: PostReviewDto) {
        self.id = dto.id
        self.review = dto.review
        self.rating = dto.rating
        self.createdAt = dto.createdAt
    }
}

extension PostServiceDomain {
    init(from dto: PostServiceDomainDto) {
        self.id = dto.id
        self.name = dto.name
    }
}

extension PostProduct {
    init(from dto: PostProductDto) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
        self.duration = dto.duration
        self.price = dto.price
        self.priceWithDiscount = dto.priceWithDiscount
        self.discount = dto.discount
        self.currency = PostProductCurrency(from: dto.currency)
    }
}

extension PostProductCurrency {
    init(from dto: PostProductCurrencyDto) {
        self.id = dto.id
        self.name = dto.name
    }
}

extension UserPostActions {
    init(from dto: UserPostActionsDto) {
        self.isLiked = dto.isLiked
        self.isBookmarked = dto.isBookmarked
        self.isReposted = dto.isReposted
    }
}

extension PostMediaFile {
    init(from dto: PostMediaFileDto) {
        self.id = dto.id
        self.url = dto.url
        self.type = dto.type
        self.thumbnailUrl = dto.thumbnailUrl
        self.duration = dto.duration
        self.postId = dto.postId
        self.orderIndex = dto.orderIndex
        self.customCoverUrl = dto.customCoverUrl
        self.status = dto.status
        self.readyToStream = dto.readyToStream
    }
}

extension Hashtag {
    init(from dto: HashtagDto) {
        self.id = dto.id
        self.name = dto.name
        self.createdAt = dto.createdAt
        self.updatedAt = dto.updatedAt
    }
}

extension PostCounters {
    init(from dto: PostCountersDto) {
        self.commentCount = dto.commentCount
        self.likeCount = dto.likeCount
        self.bookmarkCount = dto.bookmarkCount
        self.repostCount = dto.repostCount
        self.shareCount = dto.shareCount
        self.bookingsCount = dto.bookingsCount
        self.viewsCount = dto.viewsCount
    }
}
