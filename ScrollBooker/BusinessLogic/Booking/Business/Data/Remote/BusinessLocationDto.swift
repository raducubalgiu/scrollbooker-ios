//
//  BusinessLocationDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessLocationDto: Decodable {
    let address: String
    let formattedAddress: String?
    let city: String?
    let coordinates: BusinessCoordinates
    let mapUrl: String?

    enum CodingKeys: String, CodingKey {
        case address
        case formattedAddress = "formatted_address"
        case city
        case coordinates
        case mapUrl = "map_url"
    }
}
