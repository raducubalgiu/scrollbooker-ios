//
//  BusinessAddressDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

struct BusinessAddressDto: Decodable {
    let description: String
    let placeId: String

    enum CodingKeys: String, CodingKey {
        case description
        case placeId = "place_id"
    }
}
