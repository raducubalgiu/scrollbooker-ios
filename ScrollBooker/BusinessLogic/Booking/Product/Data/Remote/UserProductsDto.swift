//
//  UserProductsDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct UserProductsDto: Decodable {
    let totalCount: Int
    let data: [BusinessServicesWithProductsDto]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case data
    }
}

struct BusinessServicesWithProductsDto: Decodable {
    let service: ServiceDto
    let products: [ProductDto]
    
    enum CodingKeys: String, CodingKey {
        case service
        case products
    }
}
