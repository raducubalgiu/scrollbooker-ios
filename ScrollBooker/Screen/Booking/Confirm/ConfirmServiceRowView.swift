//
//  ConfirmServiceRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ConfirmServiceRowView: View {
    let item: SelectedBookingItem

    private var offering: ProductOffering? {
        item.offerings.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.productName)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)

            Text(item.variantDuration.formatDuration())
                .font(.subheadline)
                .foregroundColor(.gray)

            ProductCardRowPriceView(
                hasDifferentOfferings: false,
                price: offering?.price ?? 0,
                priceWithDiscount: offering?.priceWithDiscount ?? 0,
                discount: offering?.discount ?? 0
            )
        }
        .padding(.all, .base)
    }
}
