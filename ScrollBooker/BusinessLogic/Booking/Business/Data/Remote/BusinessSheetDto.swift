//
//  BusinessSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

struct BusinessSheetDto: Decodable {
    let id: Int
    let owner: BusinessOwnerDto
    let businessShortDomain: String
    let address: String
    let coordinates: BusinessCoordinates
    let mediaFiles: [BusinessMediaFileDto]
    let products: [ProductDto]
    let distance: Float?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case businessShortDomain = "business_short_domain"
        case address
        case coordinates
        case mediaFiles = "media_files"
        case products
        case distance
    }
}
