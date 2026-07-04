//
//  PaginatedResponse.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

struct PaginatedResponseDTO<Item: Decodable>: Decodable {
    let count: Int
    let results: [Item]
}

struct PaginatedResponse<Item> {
    let count: Int
    let results: [Item]
    
    init<DTO: Decodable>(
        _ dto: PaginatedResponseDTO<DTO>,
        map: (DTO) throws -> Item
    ) rethrows {
        self.count = dto.count
        self.results = try dto.results.map(map)
    }
}

extension PaginatedResponse {
    init<DTO: Decodable>(
        _ dto: PaginatedResponseDTO<DTO>,
        map: (DTO) -> Item
    ) {
        self.count = dto.count
        self.results = dto.results.map(map)
    }
}
