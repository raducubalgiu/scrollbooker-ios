//
//  Post.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import Foundation

struct Post: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let description: String?
    let user: PostUser
    let businessOwner: PostBusinessOwner
    let employee: PostEmployee?
    let counters: PostCounters
    let userActions: UserPostActions
    let mediaFiles: [PostMediaFile]
    let hashtags: [Hashtag]?
    let isVideoReview: Bool
    let isOwnPost: Bool
    let rating: Int?
    let bookable: Bool
    let businessId: Int
    let lastMinute: LastMinute
    let createdAt: String
}

struct PostUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let isFollow: Bool
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct PostBusinessOwner: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let avatar: String?
    let ratingsAverage: Float
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct PostEmployee: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let avatar: String?
}

struct PostProduct: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let description: String?
    let duration: Int
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let currency: PostProductCurrency
}

struct PostProductCurrency: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct UserPostActions: Equatable, Hashable, Sendable {
    let isLiked: Bool
    let isBookmarked: Bool
    let isReposted: Bool
}

struct PostMediaFile: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let url: String
    let type: String
    let thumbnailUrl: String
    let duration: Float?
    let postId: Int
    let orderIndex: Int
}

struct Hashtag: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let createdAt: String
    let updatedAt: String
}

struct PostCounters: Equatable, Hashable, Sendable {
    let commentCount: Int
    let likeCount: Int
    let bookmarkCount: Int
    let repostCount: Int
    let bookingsCount: Int
    let viewsCount: Int
}

struct FixedSlots: Equatable, Hashable, Sendable {
    let startTime: String
    let endTime: String
    let isBooked: Bool
}

struct LastMinute: Equatable, Hashable, Sendable {
    let isLastMinute: Bool
    let lastMinuteEnd: String?
    let hasFixedSlots: Bool
    let fixedSlots: [FixedSlots]?
}
