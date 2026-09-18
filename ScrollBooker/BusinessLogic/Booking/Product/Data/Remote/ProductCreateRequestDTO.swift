//
//  ProductCreateRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

struct ProductCreateWithFiltersRequestDTO: Encodable {
    let product: ProductCreateRequestDTO
    let filters: [ProductFilterRequestDTO]
}

struct ProductCreateRequestDTO: Encodable {
    let name: String
    let description: String?
    let serviceDomainId: Int
    let serviceId: Int
    let businessId: Int
    let currencyId: Int
    let canBeBooked: Bool
    let type: String
    let sessionsCount: Int?
    let validityDays: Int?
    let variants: [ProductVariantCreateRequestDTO]

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case serviceDomainId = "service_domain_id"
        case serviceId = "service_id"
        case businessId = "business_id"
        case currencyId = "currency_id"
        case canBeBooked = "can_be_booked"
        case type
        case sessionsCount = "sessions_count"
        case validityDays = "validity_days"
        case variants
    }
}

struct ProductVariantCreateRequestDTO: Encodable {
    let name: String
    let duration: Int
    let offerings: [ProductOfferingCreateRequestDTO]
}

struct ProductOfferingCreateRequestDTO: Encodable {
    let userId: Int
    let price: Decimal
    let priceWithDiscount: Decimal?
    let discount: Decimal

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case price
        case priceWithDiscount = "price_with_discount"
        case discount
    }
}

struct ProductFilterRequestDTO: Encodable {
    let filterId: Int
    let subFilterIds: [Int]
    let isNotApplicable: Bool

    enum CodingKeys: String, CodingKey {
        case filterId = "filter_id"
        case subFilterIds = "sub_filter_ids"
        case isNotApplicable = "is_not_applicable"
    }
}
