//
//  ProductDetailVariantCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ProductDetailVariantCardView: View {
    let name: String
    let durationText: String
    let hasDifferentPrices: Bool
    let price: Decimal
    let discount: Decimal
    let priceWithDiscount: Decimal
    let isSelected: Bool
    var onSelect: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: AppSize.base.rawValue) {
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)

                Spacer().frame(height: AppSize.xxs.rawValue)

                Text(durationText)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer().frame(height: AppSize.base.rawValue)

                ProductCardRowPriceView(
                    hasDifferentOfferings: hasDifferentPrices,
                    price: price,
                    priceWithDiscount: priceWithDiscount,
                    discount: discount
                )
            }

            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .font(.title3)
                .foregroundColor(isSelected ? .onBackgroundSB : .dividerSB)
        }
        .padding(.horizontal, .base)
        .padding(.vertical, .m)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.primarySB : Color.dividerSB, lineWidth: isSelected ? 1.5 : 1)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}
