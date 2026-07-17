//
//  BusinessProfileDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

struct BusinessProfileDto: Decodable {
    let id: Int
    let owner: BusinessProfileOwnerDto
    let openingHours: OpeningHoursDTO
    let mediaFiles: [BusinessMediaFileDto]
    let location: BusinessLocationDto
    let distanceKm: Float?
    let description: String?
    let employees: [BusinessProfileEmployeeDto]
    let schedules: [ScheduleDto]
    let reviews: BusinessProfileReviewsDto
    let posts: [BusinessProfileLatestPostDto]
    let nearbyBusinesses: [NearbyBusinessDto]
    let userProducts: UserProductsDto

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case openingHours = "opening_hours"
        case mediaFiles = "media_files"
        case location
        case distanceKm = "distance_km"
        case description
        case employees
        case schedules
        case reviews
        case posts
        case nearbyBusinesses = "nearby_businesses"
        case userProducts = "user_products"
    }
}

struct BusinessProfileLatestPostDto: Decodable {
    let id: Int
    let businessId: Int
    let user: BusinessProfileLatestPostUserDto
    let viewsCount: Int
    let mediaFiles: [PostMediaFileDto]
    
    enum CodingKeys: String, CodingKey {
        case id
        case businessId = "business_id"
        case user
        case viewsCount = "views_count"
        case mediaFiles = "media_files"
    }
}

struct BusinessProfileLatestPostUserDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case profession
    }
}

struct BusinessProfileOwnerDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let counters: BusinessProfileCountersDto
    let isFollow: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case profession
        case avatar
        case counters
        case isFollow = "is_follow"
    }
}

struct BusinessLocationDto: Decodable {
    let address: String
    let formattedAddress: String
    let coordinates: BusinessCoordinates
    let mapUrl: String?

    enum CodingKeys: String, CodingKey {
        case address
        case formattedAddress = "formatted_address"
        case coordinates
        case mapUrl = "map_url"
    }
}

struct BusinessProfileCountersDto: Decodable {
    let followersCount: Int
    let followingsCount: Int
    let ratingsAverage: Float
    let ratingsCount: Int

    enum CodingKeys: String, CodingKey {
        case followersCount = "followers_count"
        case followingsCount = "followings_count"
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
}

struct BusinessProfileEmployeeDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case profession
        case ratingsAverage = "ratings_average"
    }
}

struct BusinessProfileReviewsDto: Decodable {
    let total: Int
    let data: [BusinessProfileReviewDto]
}

struct BusinessProfileReviewDto: Decodable {
    let id: Int
    let review: String
    let rating: Int
    let reviewer: BusinessProfileReviewerDto
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case review
        case rating
        case reviewer
        case createdAt = "created_at"
    }
}

struct BusinessProfileReviewerDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
    }
}

struct NearbyBusinessOwnerDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let counters: BusinessProfileCountersDto

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case profession
        case avatar
        case counters
    }
}

struct NearbyBusinessDto: Decodable {
    let id: Int
    let owner: NearbyBusinessOwnerDto
    let mediaFiles: [BusinessMediaFileDto]
    let location: BusinessLocationDto
    let distanceKm: Float?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case mediaFiles = "media_files"
        case location
        case distanceKm = "distance_km"
    }
}
