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
    let businessLocation: PostBusinessLocationDto?
    let counters: PostCountersDto
    let userActions: UserPostActionsDto
    let mediaFiles: [PostMediaFileDto]
    let hashtags: [HashtagDto]?
    let isVideoReview: Bool
    let isOwnPost: Bool
    let businessId: Int?
    let review: PostReviewDto?
    let serviceDomain: PostServiceDomainDto?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case user
        case businessOwner = "business_owner"
        case employee
        case businessLocation = "business_location"
        case counters
        case userActions = "user_actions"
        case mediaFiles = "media_files"
        case hashtags
        case isVideoReview = "is_video_review"
        case isOwnPost = "is_own_post"
        case businessId = "business_id"
        case review
        case serviceDomain = "service_domain"
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
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case profession
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
}

struct PostEmployeeDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case profession
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
}

struct PostBusinessLocationDto: Decodable {
    let address: String
    let formattedAddress: String
    let coordinates: BusinessCoordinatesDto
    let mapUrl: String?
    let placeId: String

    enum CodingKeys: String, CodingKey {
        case address
        case formattedAddress = "formatted_address"
        case coordinates
        case mapUrl = "map_url"
        case placeId = "place_id"
    }
}

struct PostReviewDto: Decodable {
    let id: Int
    let review: String?
    let rating: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case review
        case rating
        case createdAt = "created_at"
    }
}

struct PostServiceDomainDto: Decodable {
    let id: Int
    let name: String
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
    let url: String?
    let type: String
    let thumbnailUrl: String?
    let duration: Float?
    let postId: Int
    let orderIndex: Int
    let customCoverUrl: String?
    let status: String
    let readyToStream: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case type
        case thumbnailUrl = "thumbnail_url"
        case duration
        case postId = "post_id"
        case orderIndex = "order_index"
        case customCoverUrl = "custom_cover_url"
        case status
        case readyToStream = "ready_to_stream"
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
    let shareCount: Int
    let bookingsCount: Int
    let viewsCount: Int

    enum CodingKeys: String, CodingKey {
        case commentCount = "comment_count"
        case likeCount = "like_count"
        case bookmarkCount = "bookmark_count"
        case repostCount = "repost_count"
        case shareCount = "share_count"
        case bookingsCount = "bookings_count"
        case viewsCount = "views_count"
    }
}
