//
//  UserProductsMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension UserProducts {
    init(dto: UserProductsDto) {
        self.totalCount = dto.total_count
        self.data = dto.data.map { BusinessServicesWithProducts(dto: $0) }
    }
}

extension BusinessServicesWithProducts {
    init(dto: BusinessServicesWithProductsDto) {
        self.service = Service(dto: dto.service)
        self.products = dto.products.map { Product(dto: $0) }
    }
}
