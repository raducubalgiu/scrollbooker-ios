//
//  UserSocialDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

struct UserSocialDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Double
    let isFollow: Bool
    let isBusinessOrEmployee: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profession
        case avatar
        
        case fullName = "fullname"
        case ratingsAverage = "ratings_average"
        case isFollow = "is_follow"
        case isBusinessOrEmployee = "is_business_or_employee"
    }
}
