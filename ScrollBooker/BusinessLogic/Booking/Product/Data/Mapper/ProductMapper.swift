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
        self.serviceId = dto.serviceId
        self.businessId = dto.businessId
        self.businessOwnerId = dto.businessOwnerId
        self.currencyId = dto.currencyId
        self.canBeBooked = dto.canBeBooked
        
        self.type = ProductTypeEnum.fromKey(dto.type)
        
        self.sessionsCount = dto.sessionsCount
        self.validityDays = dto.validityDays
        self.hasDifferentPrices = dto.hasDifferentPrices
        
        self.startingOffering = ProductStartingOffering(dto: dto.startingOffering)
        self.variants = dto.variants.map { ProductVariant(dto: $0) }
        self.filters = dto.filters.map { ProductFilter(dto: $0) }
    }
}

extension ProductStartingOffering {
    init(dto: ProductStartingOfferingDto) {
        self.variantId = dto.variantId
        self.variantName = dto.variantName
        self.duration = dto.duration
        self.userId = dto.userId
        self.price = dto.price
        self.discount = dto.discount
        self.priceWithDiscount = dto.priceWithDiscount
    }
}

extension ProductVariant {
    init(dto: ProductVariantDto) {
        self.id = dto.id
        self.name = dto.name
        self.duration = dto.duration
        self.startingOffering = ProductOffering(dto: dto.startingOffering)
        self.hasDifferentPrices = dto.hasDifferentPrices
        self.offerings = dto.offerings.map { ProductOffering(dto: $0) }
    }
}

extension ProductOffering {
    init(dto: ProductOfferingDto) {
        self.id = dto.id
        self.user = ProductOfferingUser(dto: dto.user)
        self.price = dto.price
        self.discount = dto.discount
        self.priceWithDiscount = dto.priceWithDiscount
    }
}

extension ProductOfferingUser {
    init(dto: ProductOfferingUserDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.profession = dto.profession
        self.avatar = dto.avatar
    }
}

extension ProductOfferingUserDto {
    var toDomain: ProductOfferingUser {
        ProductOfferingUser(dto: self)
    }
}

extension ProductFilter {
    init(dto: ProductFilterDto) {
        self.id = dto.id
        self.name = dto.name
        
        self.subFilters = dto.subFilters.map { SubFilter(dto: $0) }
        
        self.type = FilterTypeEnum.fromKey(dto.type)
        self.unit = dto.unit
        self.minim = dto.minim
        self.maxim = dto.maxim
        self.displayAsTab = dto.displayAsTab
    }
}

