//
//  LinkedProductsResponseDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct LinkedProductsBusinessDto: Decodable {
    let id: Int
    let fullname: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Float
    let ratingsCount: Int
    let distanceKm: Double?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case username
        case profession
        case avatar
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case distanceKm = "distance_km"
        case address
    }
}

struct LinkedProductsResponseDto: Decodable {
    let business: LinkedProductsBusinessDto
    let products: [ProductDto]
}
