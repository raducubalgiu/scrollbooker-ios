//
//  Product.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct SubFilter: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct Product: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let description: String?
    let serviceId: Int
    let businessId: Int
    let businessOwnerId: Int
    let currencyId: Int
    let canBeBooked: Bool

    let type: ProductTypeEnum?
    let sessionsCount: Int?
    let validityDays: Int?
    let hasDifferentPrices: Bool

    let startingOffering: StartingOffering
    let variants: [ProductVariant]
    let filters: [ProductFilter]
}

struct ProductVariant: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let duration: Int
    let startingOffering: StartingOffering
    let hasDifferentPrices: Bool

    let offerings: [ProductOffering]
}

struct StartingOffering: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let variantId: Int
    let variantName: String?

    let duration: Int
    let userId: Int

    let price: Decimal
    let discount: Decimal
    let priceWithDiscount: Decimal
}

struct ProductOffering: Identifiable, Equatable, Hashable, Sendable {
    let id: Int

    let user: ProductOfferingUser
    let price: Decimal
    let discount: Decimal
    let priceWithDiscount: Decimal
}

struct ProductOfferingUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let profession: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct ProductFilter: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let subFilters: [SubFilter]
    let type: FilterTypeEnum?
    let unit: String?
    let minim: Decimal?
    let maxim: Decimal?
    let displayAsTab: Bool
}

extension Product {
    func getDurationText(minutes: Int) -> String {
        if minutes == 0 { return "0min" }

        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        let hoursPart = hours > 0 ? "\(hours)h" : ""
        let minutesPart = remainingMinutes > 0 ? "\(remainingMinutes)min" : ""

        return [hoursPart, minutesPart]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    func getFiltersSummary() -> String {
        let filterParts: [String] = self.filters.compactMap { (filter) -> String? in
            guard let type = filter.type else { return nil }
            
            switch type {
            case .options:
                return filter.subFilters.map { $0.name }.joined(separator: " & ")
                
            case .range:
                let unit = filter.unit ?? ""
                
                switch (filter.minim, filter.maxim) {
                case let (.some(min), .none):
                    return "> \(min) \(unit)".trimmingCharacters(in: .whitespaces)
                case let (.none, .some(max)):
                    return "< \(max) \(unit)".trimmingCharacters(in: .whitespaces)
                case let (.some(min), .some(max)):
                    return "\(min) - \(max) \(unit)".trimmingCharacters(in: .whitespaces)
                default:
                    return nil
                }
            }
        }

        return filterParts.joined(separator: " • ")
    }
}
