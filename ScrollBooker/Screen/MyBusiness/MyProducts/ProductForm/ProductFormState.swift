//
//  ProductFormState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation

struct ProductOfferingFormState: Identifiable, Equatable {
    let id = UUID()
    let userId: Int
    var isSelected: Bool = false
    var price: String = ""
    var discount: String = ""

    var isValid: Bool {
        guard isSelected else { return true }
        guard let priceDecimal = Decimal(string: price), priceDecimal > 0 else { return false }
        let discountValue = discount.isEmpty ? "0" : discount
        guard let discountDecimal = Decimal(string: discountValue),
              discountDecimal >= 0, discountDecimal <= 100 else { return false }
        return true
    }

    var priceWithDiscount: Decimal {
        let priceDecimal = Decimal(string: price) ?? 0
        let discountDecimal = Decimal(string: discount.isEmpty ? "0" : discount) ?? 0
        return ProductPriceCalculator.priceWithDiscount(price: priceDecimal, discountPercent: discountDecimal)
    }
}

struct ProductVariantFormState: Identifiable, Equatable {
    let id = UUID()
    // nil for a variant that only exists locally (Add, or a not-yet-saved variant added
    // while editing); set once it's been created/loaded server-side — distinguishes
    // "create variant" from "update variant" when editing an existing product.
    var backendId: Int? = nil
    var name: String = ""
    var duration: String = ""
    var offerings: [ProductOfferingFormState] = []

    var isNameValid: Bool {
        (2...50).contains(name.trimmingCharacters(in: .whitespacesAndNewlines).count)
    }

    var isDurationValid: Bool {
        (Int(duration) ?? 0) > 0
    }

    var selectedOfferings: [ProductOfferingFormState] {
        offerings.filter(\.isSelected)
    }

    var hasSelectedOffering: Bool {
        !selectedOfferings.isEmpty
    }

    var isValid: Bool {
        isNameValid && isDurationValid && hasSelectedOffering && offerings.allSatisfy(\.isValid)
    }

    var cheapestSelectedOffering: ProductOfferingFormState? {
        selectedOfferings.min { ($0.priceWithDiscount) < ($1.priceWithDiscount) }
    }
}

enum ProductPriceCalculator {
    static func priceWithDiscount(price: Decimal, discountPercent: Decimal) -> Decimal {
        let clampedDiscount = max(0, min(100, discountPercent))
        let multiplier = (Decimal(100) - clampedDiscount) / Decimal(100)

        var result = price * multiplier
        var rounded = Decimal()
        NSDecimalRound(&rounded, &result, 2, .plain)
        return rounded
    }
}
