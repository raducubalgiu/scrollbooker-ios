//
//  BusinessOwnerDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

struct BusinessOwnerDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let ratingsAverage: Float
    let ratingsCount: Int
    let profession: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case profession
    }
}
