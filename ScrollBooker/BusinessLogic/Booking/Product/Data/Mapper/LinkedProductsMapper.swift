//
//  LinkedProductsMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

extension LinkedProductsBusinessSummary {
    init(dto: LinkedProductsBusinessDto) {
        self.id = dto.id
        self.fullName = dto.fullname
        self.username = dto.username
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
        self.distanceKm = dto.distanceKm
        self.address = dto.address
    }
}

extension LinkedProducts {
    init(dto: LinkedProductsResponseDto) {
        self.business = LinkedProductsBusinessSummary(dto: dto.business)
        self.products = dto.products.map { Product(dto: $0) }
    }
}
