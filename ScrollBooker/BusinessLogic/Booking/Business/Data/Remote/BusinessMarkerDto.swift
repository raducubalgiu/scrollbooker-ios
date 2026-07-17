//
//  BusinessMarkerDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation
import CoreLocation

struct BusinessMarkerDto: Decodable {
    let id: Int
    let owner: BusinessOwnerDto
    let businessShortDomain: String
    let address: String
    let coordinates: BusinessCoordinatesDto
    let isPrimary: Bool
    let mediaFiles: [BusinessMediaFileDto?]

    enum CodingKeys: String, CodingKey {
        case id, owner, address, coordinates
        case businessShortDomain = "business_short_domain"
        case isPrimary = "is_primary"
        case mediaFiles = "media_files"
    }
}
