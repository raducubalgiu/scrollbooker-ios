//
//  ProductDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct SubFilterDto: Codable {
    let id: Int
    let name: String
}

struct ProductOfferingUserDto: Codable {
    let id: Int
    let username: String
    let fullname: String
    let profession: String
    let avatar: String?
}

struct ProductOfferingDto: Codable {
    let id: Int
    let user: ProductOfferingUserDto
    let price: Decimal
    let discount: Decimal
    let price_with_discount: Decimal
}

struct StartingOfferingDto: Codable {
    let id: Int
    let variant_id: Int
    let variant_name: String?
    let duration: Int
    let user_id: Int
    let price: Decimal
    let discount: Decimal
    let price_with_discount: Decimal
}

struct ProductVariantDto: Codable {
    let id: Int
    let name: String
    let duration: Int
    let starting_offering: StartingOfferingDto
    let has_different_prices: Bool
    let offerings: [ProductOfferingDto]
}

struct ProductFilterDto: Codable {
    let id: Int
    let name: String
    let sub_filters: [SubFilterDto]
    let type: String
    let unit: String?
    let minim: Decimal?
    let maxim: Decimal?
    let display_as_tab: Bool
}

struct ProductDto: Codable {
    let id: Int
    let name: String
    let description: String?
    let service_id: Int
    let business_id: Int
    let business_owner_id: Int
    let currency_id: Int
    let can_be_booked: Bool
    let type: String
    let sessions_count: Int?
    let validity_days: Int?
    let has_different_prices: Bool
    let starting_offering: StartingOfferingDto
    let variants: [ProductVariantDto]
    let filters: [ProductFilterDto]
}

