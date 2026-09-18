//
//  ProductBaseInfoUpdateRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

struct ProductBaseInfoUpdateRequestDTO: Encodable {
    let name: String
    let description: String?
    let serviceDomainId: Int
    let serviceId: Int
    let canBeBooked: Bool
    let type: String
    let sessionsCount: Int?
    let validityDays: Int?
    let filters: [ProductFilterRequestDTO]

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case serviceDomainId = "service_domain_id"
        case serviceId = "service_id"
        case canBeBooked = "can_be_booked"
        case type
        case sessionsCount = "sessions_count"
        case validityDays = "validity_days"
        case filters
    }
}
