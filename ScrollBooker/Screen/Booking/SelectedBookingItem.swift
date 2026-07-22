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

import Foundation

extension Collection where Element == SelectedBookingItem {
    func toProductVariantsDto() -> [AppointmentProductVariantCreateDto] {
        return self.map { item in
            guard let firstOffering = item.offerings.first else {
                fatalError("No offering available for variant \(item.variantId)")
            }
            
            return AppointmentProductVariantCreateDto(
                id: item.variantId,
                offering: AppointmentProductOfferingCreateDto(
                    userId: firstOffering.user.id
                )
            )
        }
    }
}

