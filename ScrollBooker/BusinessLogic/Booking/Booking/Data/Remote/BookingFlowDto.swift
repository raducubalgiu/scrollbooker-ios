//
//  BookingFlowDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BookingFlowDto: Codable {
    let business: BookingFlowBusinessDto
    let products: UserProductsDto
    let employees: [BookingFlowUserDto]
}

struct BookingFlowBusinessDto: Codable {
    let owner: BookingFlowUserDto
    let has_employees: Bool
    let formatted_address: String
}

struct BookingFlowUserDto: Codable {
    let id: Int
    let username: String
    let fullname: String
    let profession: String
    let avatar: String?
    let ratings_count: Int
    let ratings_average: Float
}
