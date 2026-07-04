//
//  UserProducts.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct UserProducts: Equatable, Hashable, Sendable {
    let totalCount: Int
    let data: [BusinessServicesWithProducts]
}

struct BusinessServicesWithProducts: Equatable, Hashable, Sendable {
    let service: Service
    let products: [Product]
}
