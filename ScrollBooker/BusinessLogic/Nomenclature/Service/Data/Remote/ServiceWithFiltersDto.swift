//
//  ServiceWithFiltersDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

struct ServiceWithFiltersDto: Decodable {
    let id: Int
    let name: String
    let shortName: String
    let description: String?
    let businessDomainId: Int
    let filters: [FilterDto]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
        case description
        case businessDomainId = "business_domain_id"
        case filters
    }
}
