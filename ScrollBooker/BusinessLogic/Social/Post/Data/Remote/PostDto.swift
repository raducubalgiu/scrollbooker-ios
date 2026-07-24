//
//  PostDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

struct PostDto: Decodable {
    let id: Int
    let description: String?
    let user: PostUserDto
    let businessOwner: PostBusinessOwnerDto
    let employee: PostEmployeeDto?
    let counters: PostCountersDto
    let userActions: UserPostActionsDto
    let mediaFiles: [PostMediaFileDto]
    let hashtags: [HashtagDto]?
    let isVideoReview: Bool
    let isOwnPost: Bool
    let rating: Int?
    let bookable: Bool
    let businessId: Int
    let lastMinute: LastMinuteDto
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case user
        case businessOwner = "business_owner"
        case employee
        case counters
        case userActions = "user_actions"
        case mediaFiles = "media_files"
        case hashtags
        case isVideoReview = "is_video_review"
        case isOwnPost = "is_own_post"
        case rating
        case bookable
        case businessId = "business_id"
        case lastMinute = "last_minute"
        case createdAt = "created_at"
    }
}

struct PostUserDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let isFollow: Bool
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case isFollow = "is_follow"
        case profession
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
}

struct PostBusinessOwnerDto: Decodable {
    let id: Int
    let fullName: String
    let avatar: String?
    let ratingsAverage: Float

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case avatar
        case ratingsAverage = "ratings_average"
    }
}

struct PostEmployeeDto: Decodable {
    let id: Int
    let fullName: String
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case avatar
    }
}

struct PostProductDto: Decodable {
    let id: Int
    let name: String
    let description: String?
    let duration: Int
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let currency: PostProductCurrencyDto

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case duration
        case price
        case priceWithDiscount = "price_with_discount"
        case discount
        case currency
    }
}

struct PostProductCurrencyDto: Decodable {
    let id: Int
    let name: String
}

struct UserPostActionsDto: Decodable {
    let isLiked: Bool
    let isBookmarked: Bool
    let isReposted: Bool

    enum CodingKeys: String, CodingKey {
        case isLiked = "is_liked"
        case isBookmarked = "is_bookmarked"
        case isReposted = "is_reposted"
    }
}

struct PostMediaFileDto: Decodable {
    let id: Int
    let url: String
    let type: String
    let thumbnailUrl: String
    let duration: Float?
    let postId: Int
    let orderIndex: Int

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case type
        case thumbnailUrl = "thumbnail_url"
        case duration
        case postId = "post_id"
        case orderIndex = "order_index"
    }
}

struct HashtagDto: Decodable {
    let id: Int
    let name: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct PostCountersDto: Decodable {
    let commentCount: Int
    let likeCount: Int
    let bookmarkCount: Int
    let repostCount: Int
    let bookingsCount: Int
    let viewsCount: Int

    enum CodingKeys: String, CodingKey {
        case commentCount = "comment_count"
        case likeCount = "like_count"
        case bookmarkCount = "bookmark_count"
        case repostCount = "repost_count"
        case bookingsCount = "bookings_count"
        case viewsCount = "views_count"
    }
}

struct FixedSlotsDto: Decodable {
    let startTime: String
    let endTime: String
    let isBooked: Bool

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case isBooked = "is_booked"
    }
}

struct LastMinuteDto: Decodable {
    let isLastMinute: Bool
    let lastMinuteEnd: String?
    let hasFixedSlots: Bool
    let fixedSlots: [FixedSlotsDto]?

    enum CodingKeys: String, CodingKey {
        case isLastMinute = "is_last_minute"
        case lastMinuteEnd = "last_minute_end"
        case hasFixedSlots = "has_fixed_slots"
        case fixedSlots = "fixed_slots"
    }
}
