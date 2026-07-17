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
    let date_of_birth: String?
    let bio: String?
    let website: String?
    let public_email: String?
    let instagram: String?
    let tiktok: String?
    let business_id: Int?
    let business_type_id: Int?
    let counters: UserCountersDTO
    let profession: String
    let opening_hours: OpeningHoursDTO
    let is_follow: Bool
    let business_owner: ProfileBusinessOwnerDTO?
    let is_own_profile: Bool
    let is_business_or_employee: Bool
    let distance_km: Double?
    let address: String?
    
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
    let user_id: Int
    let followings_count: Int
    let followers_count: Int
    let products_count: Int
    let posts_count: Int
    let ratings_count: Int
    let ratings_average: Float
}

struct OpeningHoursDTO: Decodable {
    let open_now: Bool
    let closing_time: String?
    let next_open_day: String?
    let next_open_time: String?
}

