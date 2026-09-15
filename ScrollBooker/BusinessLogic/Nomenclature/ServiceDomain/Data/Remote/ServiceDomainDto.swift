//
//  ServiceDomainDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ServiceDomainDto: Decodable {
    let id: Int
    let name: String
    let description: String?
    let url: String?
    let thumbnailUrl: String?
    let services: [ServiceDto]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case url
        case thumbnailUrl = "thumbnail_url"
        case services
    }
}
