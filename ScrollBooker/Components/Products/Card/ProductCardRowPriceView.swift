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
        HStack(alignment: .center, spacing: AppSize.xs.rawValue) {
            if hasDifferentOfferings {
                Text(String(localized: "from"))
                    .font(.footnote)
                    .foregroundColor(Color.onBackgroundSB)
            }

            Text("\(priceWithDiscount.toTwoDecimals()) RON")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.onBackgroundSB)

            if discount > 0 {
                Text(price.toTwoDecimals())
                    .font(.footnote)
                    .strikethrough()
                    .foregroundColor(.gray)

                Text("(-\(discount.toTwoDecimals())%)")
                    .font(.footnote)
                    .foregroundColor(.errorSB)
            }

            Spacer()
        }
    }
}
