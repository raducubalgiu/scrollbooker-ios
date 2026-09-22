//
//  BusinessClientDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

struct BusinessClientDTO: Decodable {
    let id: Int
    let businessId: Int
    let userId: Int?
    let fullname: String
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case id
        case businessId = "business_id"
        case userId = "user_id"
        case fullname
        case phone
    }
}

struct BusinessClientCreateRequestDTO: Encodable {
    let fullname: String
    let phone: String?
}
