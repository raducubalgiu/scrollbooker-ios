//
//  BusinessFileDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

struct BusinessMediaFileDto: Decodable {
    let url: String
    let urlKey: String
    let thumbnailUrl: String
    let thumbnailKey: String
    let type: String
    let orderIndex: Int

    enum CodingKeys: String, CodingKey {
        case url
        case urlKey = "url_key"
        case thumbnailUrl = "thumbnail_url"
        case thumbnailKey = "thumbnail_key"
        case type
        case orderIndex = "order_index"
    }
}
