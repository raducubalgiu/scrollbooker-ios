//
//  ProductDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ProductDto: Decodable {
    let id: Int
    let name: String
    let description: String?
    let serviceId: Int
    let businessId: Int
    let businessOwnerId: Int
    let currencyId: Int
    let canBeBooked: Bool
    let type: String
    let sessionsCount: Int?
    let validityDays: Int?
    let hasDifferentPrices: Bool
    let startingOffering: ProductStartingOfferingDto
    let variants: [ProductVariantDto]
    let filters: [ProductFilterDto]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case serviceId = "service_id"
        case businessId = "business_id"
        case businessOwnerId = "business_owner_id"
        case currencyId = "currency_id"
        case canBeBooked = "can_be_booked"
        case type
        case sessionsCount = "sessions_count"
        case validityDays = "validity_days"
        case hasDifferentPrices = "has_different_prices"
        case startingOffering = "starting_offering"
        case variants
        case filters
    }
}

struct ProductStartingOfferingDto: Decodable {
    let variantId: Int
    let variantName: String
    let duration: Int
    let userId: Int

    @LossyDecimal
    var price: Decimal

    @LossyDecimal
    var discount: Decimal

    @LossyDecimal
    var priceWithDiscount: Decimal

    enum CodingKeys: String, CodingKey {
        case variantId = "variant_id"
        case variantName = "variant_name"
        case userId = "user_id"
        case duration
        case price
        case discount
        case priceWithDiscount = "price_with_discount"
    }
}

struct ProductOfferingDto: Decodable {
    let id: Int
    let user: ProductOfferingUserDto

    @LossyDecimal
    var price: Decimal

    @LossyDecimal
    var discount: Decimal

    @LossyDecimal
    var priceWithDiscount: Decimal

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case price
        case discount
        case priceWithDiscount = "price_with_discount"
    }
}

struct ProductVariantDto: Decodable {
    let id: Int
    let name: String
    let duration: Int
    let startingOffering: ProductOfferingDto
    let hasDifferentPrices: Bool
    let offerings: [ProductOfferingDto]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case duration
        case startingOffering = "starting_offering"
        case hasDifferentPrices = "has_different_prices"
        case offerings
    }
}

struct ProductOfferingUserDto: Decodable {
    let id: Int
    let username: String
    let fullName: String
    let profession: String
    let avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "fullname"
        case profession
        case avatar
    }
}

struct ProductFilterDto: Decodable {
    let id: Int
    let name: String
    let subFilters: [SubFilterDto]
    let type: String
    let unit: String?
    
    @LossyOptionalDecimal
    var minim: Decimal?
    
    @LossyOptionalDecimal
    var maxim: Decimal?
    
    let displayAsTab: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case subFilters = "sub_filters"
        case type
        case unit
        case minim
        case maxim
        case displayAsTab = "display_as_tab"
    }
}

