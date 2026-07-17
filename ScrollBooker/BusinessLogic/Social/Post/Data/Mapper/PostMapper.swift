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
        self.counters = PostCounters(from: dto.counters)
        self.userActions = UserPostActions(from: dto.userActions)
        self.mediaFiles = dto.mediaFiles.map { PostMediaFile(from: $0) }
        self.hashtags = dto.hashtags?.map { Hashtag(from: $0) }
        self.isVideoReview = dto.isVideoReview
        self.isOwnPost = dto.isOwnPost
        self.rating = dto.rating
        self.bookable = dto.bookable
        self.businessId = dto.businessId
        self.lastMinute = LastMinute(from: dto.lastMinute)
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
        self.avatar = dto.avatar
        self.ratingsAverage = dto.ratingsAverage
    }
}

extension PostEmployee {
    init(from dto: PostEmployeeDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.avatar = dto.avatar
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
        self.bookingsCount = dto.bookingsCount
        self.viewsCount = dto.viewsCount
    }
}

extension FixedSlots {
    init(from dto: FixedSlotsDto) {
        self.startTime = dto.startTime
        self.endTime = dto.endTime
        self.isBooked = dto.isBooked
    }
}

extension LastMinute {
    init(from dto: LastMinuteDto) {
        self.isLastMinute = dto.isLastMinute
        self.lastMinuteEnd = dto.lastMinuteEnd
        self.hasFixedSlots = dto.hasFixedSlots
        self.fixedSlots = dto.fixedSlots?.map { FixedSlots(from: $0) }
    }
}
