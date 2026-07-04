//
//  ProductMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Product {
    init(dto: ProductDto) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
        self.serviceId = dto.service_id
        self.businessId = dto.business_id
        self.businessOwnerId = dto.business_owner_id
        self.currencyId = dto.currency_id
        self.canBeBooked = dto.can_be_booked
        
        self.type = ProductTypeEnum.fromKey(dto.type)
        
        self.sessionsCount = dto.sessions_count
        self.validityDays = dto.validity_days
        self.hasDifferentPrices = dto.has_different_prices
        
        self.startingOffering = StartingOffering(dto: dto.starting_offering)
        self.variants = dto.variants.map { ProductVariant(dto: $0) }
        self.filters = dto.filters.map { ProductFilter(dto: $0) }
    }
}

extension ProductVariant {
    init(dto: ProductVariantDto) {
        self.id = dto.id
        self.name = dto.name
        self.duration = dto.duration
        self.startingOffering = StartingOffering(dto: dto.starting_offering)
        self.hasDifferentPrices = dto.has_different_prices
        self.offerings = dto.offerings.map { ProductOffering(dto: $0) }
    }
}

extension StartingOffering {
    init(dto: StartingOfferingDto) {
        self.id = dto.id
        self.variantId = dto.variant_id
        self.variantName = dto.variant_name
        self.duration = dto.duration
        self.userId = dto.user_id
        self.price = dto.price
        self.discount = dto.discount
        self.priceWithDiscount = dto.price_with_discount
    }
}

extension ProductOffering {
    init(dto: ProductOfferingDto) {
        self.id = dto.id
        self.user = ProductOfferingUser(dto: dto.user)
        self.price = dto.price
        self.discount = dto.discount
        self.priceWithDiscount = dto.price_with_discount
    }
}

extension ProductOfferingUser {
    init(dto: ProductOfferingUserDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullname
        self.profession = dto.profession
        self.avatar = dto.avatar
    }
}

extension ProductFilter {
    init(dto: ProductFilterDto) {
        self.id = dto.id
        self.name = dto.name
        
        self.subFilters = dto.sub_filters.map { SubFilter(dto: $0) }
        
        self.type = FilterTypeEnum.fromKey(dto.type)
        self.unit = dto.unit
        self.minim = dto.minim
        self.maxim = dto.maxim
        self.displayAsTab = dto.display_as_tab
    }
}

