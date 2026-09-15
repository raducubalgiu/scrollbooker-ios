//
//  BusinessCreateRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessCreateRequestDTO: Encodable {
    let description: String?
    let placeId: String
    let businessTypeId: Int
    let ownerFullName: String

    enum CodingKeys: String, CodingKey {
        case description
        case placeId = "place_id"
        case businessTypeId = "business_type_id"
        case ownerFullName = "owner_fullname"
    }
}
