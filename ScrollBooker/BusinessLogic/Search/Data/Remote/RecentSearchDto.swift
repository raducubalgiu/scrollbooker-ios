//
//  RecentSearchDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct RecentSearchDto: Decodable {
    let id: Int
    let businessDomainId: Int?
    let serviceDomain: RecentSearchServiceDomainDto
    let services: [RecentSearchServiceDto]

    enum CodingKeys: String, CodingKey {
        case id
        case businessDomainId = "business_domain_id"
        case serviceDomain = "service_domain"
        case services
    }
}

struct RecentSearchServiceDomainDto: Decodable {
    let id: Int
    let name: String
}

struct RecentSearchServiceDto: Decodable {
    let id: Int
    let name: String
    let filters: [RecentSearchFilterDto]
}

struct RecentSearchFilterDto: Decodable {
    let id: Int
    let name: String
    let subFilters: [RecentSearchSubFilterDto]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case subFilters = "sub_filters"
    }
}

struct RecentSearchSubFilterDto: Decodable {
    let id: Int
    let name: String
}
