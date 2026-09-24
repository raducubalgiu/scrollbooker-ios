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

    private var subtitleText: String {
        let durationText = item.variantDuration.formatDuration()
        return item.variantName.isEmpty ? durationText : "\(durationText) - \(item.variantName)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: AppSize.s.rawValue) {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.productName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(2)
                    .truncationMode(.tail)

                Spacer().frame(height: 4)

                Text(subtitleText)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)

                Spacer().frame(height: 6)

                ProductCardRowPriceView(
                    hasDifferentOfferings: item.hasPriceVariance,
                    price: item.offerings.first?.price ?? 0,
                    priceWithDiscount: item.offerings.first?.priceWithDiscount ?? 0,
                    discount: item.offerings.first?.discount ?? 0
                )
            }

            Spacer()

            Button {
                onRemove()
            } label: {
                Image(systemName: "trash")
                    .font(.footnote)
                    .foregroundColor(.errorSB)
                    .frame(width: 28, height: 28)
                    .background(Color.backgroundSB)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.base)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
