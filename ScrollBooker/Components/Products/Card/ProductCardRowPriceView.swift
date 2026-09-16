//
//  ProductCardRowPriceView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct ProductCardRowPriceView: View {
    let hasDifferentOfferings: Bool
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if hasDifferentOfferings {
                Text(String(localized: "from"))
                    .font(.subheadline)
                    .foregroundColor(Color.onBackgroundSB)
            }

            Text("\(priceWithDiscount.toTwoDecimals()) RON")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.onBackgroundSB)

            if discount > 0 {
                Text(price.toTwoDecimals())
                    .font(.subheadline)
                    .strikethrough()
                    .foregroundColor(.gray)

                Text("(-\(discount.toTwoDecimals())%)")
                    .font(.subheadline)
                    .foregroundColor(.errorSB)
            }

            Spacer()
        }
    }
}
