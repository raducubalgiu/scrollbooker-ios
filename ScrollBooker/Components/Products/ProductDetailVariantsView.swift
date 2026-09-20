//
//  ProductDetailVariantsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ProductDetailVariantsView: View {
    let product: Product
    let variants: [ProductVariant]
    let selectedVariant: ProductVariant?
    var onSelectVariant: (ProductVariant) -> Void

    var body: some View {
        if variants.count > 1 {
            VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
                Text("\(String(localized: "selectAnOption"))*")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)

                VStack(spacing: AppSize.xs.rawValue) {
                    ForEach(variants) { variant in
                        ProductDetailVariantCardView(
                            name: variant.name,
                            durationText: product.getDurationText(minutes: variant.duration),
                            hasDifferentPrices: variant.hasDifferentPrices,
                            price: variant.startingOffering.price,
                            discount: variant.startingOffering.discount,
                            priceWithDiscount: variant.startingOffering.priceWithDiscount,
                            isSelected: selectedVariant?.id == variant.id,
                            onSelect: { onSelectVariant(variant) }
                        )
                    }
                }
            }
            .padding(.horizontal, .base)
        }
    }
}
