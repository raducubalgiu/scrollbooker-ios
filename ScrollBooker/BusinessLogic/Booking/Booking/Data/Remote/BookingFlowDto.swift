//
//  BookingFlowDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BookingFlowDto: Decodable {
    let business: BookingFlowBusinessDto
    let products: UserProductsDto
    let employees: [BookingFlowUserDto]
    
    enum CodingKeys: String, CodingKey {
        case business
        case products
        case employees
    }
}

struct BookingFlowBusinessDto: Decodable {
    let owner: BookingFlowUserDto
    let hasEmployees: Bool
    let formattedAddress: String
    
    enum CodingKeys: String, CodingKey {
        case owner
        case hasEmployees = "has_employees"
        case formattedAddress = "formatted_address"
    }
}

struct BookingFlowUserDto: Decodable {
    let id: Int
    let username: String
    let fullName: String
    let profession: String
    let avatar: String?
    let ratingsCount: Int
    let ratingsAverage: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "fullname"
        case profession
        case avatar
        case ratingsCount = "ratings_count"
        case ratingsAverage = "ratings_average"
    }
}
