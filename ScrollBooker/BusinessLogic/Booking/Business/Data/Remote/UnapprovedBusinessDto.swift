//
//  UnapprovedBusinessDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct UnapprovedBusinessDto: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let business: UnapprovedBusinessDataDto

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case business
    }
}

struct UnapprovedBusinessDataDto: Decodable {
    let id: Int
    let hasEmployees: Bool
    let location: UnapprovedLocationDto
    let businessType: UnapprovedBusinessTypeDto

    enum CodingKeys: String, CodingKey {
        case id
        case hasEmployees = "has_employees"
        case location
        case businessType = "business_type"
    }
}

struct UnapprovedLocationDto: Decodable {
    let coordinates: BusinessCoordinatesDto
    let address: String
}

struct UnapprovedBusinessTypeDto: Decodable {
    let id: Int
    let name: String
}
