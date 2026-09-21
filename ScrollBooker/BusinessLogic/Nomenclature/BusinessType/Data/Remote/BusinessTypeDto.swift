//
//  BusinessTypeDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BusinessTypeDto: Decodable {
    let id: Int
    let name: String
    let plural: String
    let businessDomainId: Int?
    let url: String?
    let thumbnailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case plural
        case businessDomainId = "business_domain_id"
        case url
        case thumbnailUrl = "thumbnail_url"
    }
}
