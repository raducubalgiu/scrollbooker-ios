//
//  UserProductsDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct UserProductsDto: Codable {
    let total_count: Int
    let data: [BusinessServicesWithProductsDto]
}

struct BusinessServicesWithProductsDto: Codable {
    let service: ServiceDto
    let products: [ProductDto]
}
