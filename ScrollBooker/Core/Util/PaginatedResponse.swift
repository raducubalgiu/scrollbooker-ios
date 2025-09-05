//
//  PaginatedResponse.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation

struct PaginatedResponseDTO<Item: Codable>: Codable {
    let count: Int
    let results: [Item]
}

struct PaginatedResponse<Item> {
    let count: Int
    let results: [Item]
}

extension PaginatedResponse {
    init<T>(_ dto: PaginatedResponseDTO<T>, map: (T) -> Item) {
        self.count = dto.count
        self.results = dto.results.map(map)
    }
}
