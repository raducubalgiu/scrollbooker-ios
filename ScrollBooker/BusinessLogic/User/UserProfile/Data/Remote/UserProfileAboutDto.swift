//
//  UserProfileAboutDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

import Foundation

struct UserProfileAboutDto: Decodable {
    let description: String?
    let schedules: [ScheduleDto]
    let location: BusinessLocationDto
    let owner: UserProfileAboutOwnnerDto
    let businessMedia: [BusinessMediaFileDto]
    
    enum CodingKeys: String, CodingKey {
        case description
        case schedules
        case location
        case owner
        case businessMedia = "business_media"
    }
}

struct UserProfileAboutOwnnerDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case profession
        case avatar
        case ratingsAverage = "ratings_average"
    }
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

