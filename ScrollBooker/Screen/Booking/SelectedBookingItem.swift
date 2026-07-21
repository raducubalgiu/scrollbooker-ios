//
//  SelectedBookingItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

struct SelectedBookingItem: Identifiable, Equatable, Hashable, Sendable {
    var id: Int { productId }
    let productId: Int
    let variantId: Int
    let variantDuration: Int
    let offerings: [ProductOffering]
    let productName: String
    let variantName: String
    
    var hasPriceVariance: Bool {
        guard offerings.count > 1 else { return false }
        let firstPrice = offerings.first?.priceWithDiscount

        return offerings.contains { $0.priceWithDiscount != firstPrice }
    }
}
