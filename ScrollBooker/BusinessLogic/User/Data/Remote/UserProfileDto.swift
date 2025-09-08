//
//  UserProfileDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import Foundation

struct UserProfileDTO: Codable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
    let gender: String
    let bio: String?
    let business_id: Int?
    let business_type_id: Int?
    let counters: UserCountersDTO
    let profession: String
    let opening_hours: OpeningHoursDTO
    let is_follow: Bool
    let business_owner: BusinessOwnerDTO?
    let is_own_profile: Bool
    let is_business_or_employee: Bool
    let distance_km: Double?
    let address: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct BusinessOwnerDTO: Codable{
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
    let is_follow: Bool
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct UserCountersDTO: Codable {
    let user_id: Int
    let followings_count: Int
    let followers_count: Int
    let products_count: Int
    let posts_count: Int
    let ratings_count: Int
    let ratings_average: Decimal
}

struct OpeningHoursDTO: Codable {
    let open_now: Bool
    let closing_time: String?
    let next_open_day: String?
    let next_open_time: String?
}

