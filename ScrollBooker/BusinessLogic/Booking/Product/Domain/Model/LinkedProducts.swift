//
//  LinkedProducts.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct LinkedProductsBusinessSummary: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Float
    let ratingsCount: Int
    let distanceKm: Double?
    let address: String?

    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct LinkedProducts: Equatable, Hashable, Sendable {
    let business: LinkedProductsBusinessSummary
    let products: [Product]
}
