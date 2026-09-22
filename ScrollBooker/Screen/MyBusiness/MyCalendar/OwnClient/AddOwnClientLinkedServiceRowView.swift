//
//  AddOwnClientLinkedServiceRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientLinkedServiceRowView: View {
    let item: SelectedBookingItem
    var onRemove: () -> Void

    private var priceText: String {
        let price = item.offerings.first?.priceWithDiscount ?? 0
        return String(format: "%.2f", NSDecimalNumber(decimal: price).doubleValue)
    }

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.productName)
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)

                Text(item.variantName)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(priceText)
                .font(.footnote.bold())
                .foregroundColor(.onBackgroundSB)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, .s)
    }
}
