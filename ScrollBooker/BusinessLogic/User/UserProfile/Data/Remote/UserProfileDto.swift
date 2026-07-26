//
//  UserProfileDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import Foundation

struct UserProfileDTO: Decodable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
    let gender: String
    let dateOfBirth: String?
    let bio: String?
    let website: String?
    let publicEmail: String?
    let instagram: String?
    let tiktok: String?
    let businessId: Int?
    let businessTypeId: Int?
    let counters: UserCountersDTO
    let profession: String
    let openingHours: OpeningHoursDTO
    let isFollow: Bool
    let businessOwner: ProfileBusinessOwnerDTO?
    let isOwnProfile: Bool
    let isBusinessOrEmployee: Bool
    let distanceKm: Double?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullname
        case avatar
        case gender
        case dateOfBirth = "date_of_birth"
        case bio
        case website
        case publicEmail = "public_email"
        case instagram
        case tiktok
        case businessId = "business_id"
        case businessTypeId = "business_type_id"
        case counters
        case profession
        case openingHours = "opening_hours"
        case isFollow = "is_follow"
        case businessOwner = "business_owner"
        case isOwnProfile = "is_own_profile"
        case isBusinessOrEmployee = "is_business_or_employee"
        case distanceKm
        case address
    }
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct ProfileBusinessOwnerDTO: Decodable{
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct UserCountersDTO: Decodable {
    let userId: Int
    let followingsCount: Int
    let followersCount: Int
    let productsCount: Int
    let postsCount: Int
    let ratingsCount: Int
    let ratingsAverage: Float
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case followingsCount = "followings_count"
        case followersCount = "followers_count"
        case productsCount = "products_count"
        case postsCount = "posts_count"
        case ratingsCount = "ratings_count"
        case ratingsAverage = "ratings_average"
    }
}

struct OpeningHoursDTO: Decodable {
    let openNow: Bool
    let closingTime: String?
    let nextOpenDay: String?
    let nextOpenTime: String?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case closingTime = "closing_time"
        case nextOpenDay = "next_open_day"
        case nextOpenTime = "next_open_time"
    }
}

