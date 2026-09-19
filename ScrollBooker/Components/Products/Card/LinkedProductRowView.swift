//
//  LinkedProductRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct LinkedProductRowView: View {
    let product: Product
    var onEdit: (Product) -> Void
    var onRemove: (Product) -> Void

    private var filtersSummary: String { product.getFiltersSummary() }

    var body: some View {
        HStack(alignment: .center, spacing: AppSize.s.rawValue) {
            VStack(alignment: .leading, spacing: 0) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(2)
                    .truncationMode(.tail)

                if !filtersSummary.isEmpty {
                    Spacer().frame(height: 4)

                    Text(filtersSummary)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }

                Spacer().frame(height: 6)

                ProductCardRowPriceView(
                    hasDifferentOfferings: product.hasDifferentPrices,
                    price: product.startingOffering.price,
                    priceWithDiscount: product.startingOffering.priceWithDiscount,
                    discount: product.startingOffering.discount
                )
            }

            Spacer()

            VStack(spacing: AppSize.s.rawValue) {
                Button {
                    onEdit(product)
                } label: {
                    Image(systemName: "pencil")
                        .font(.footnote)
                        .foregroundColor(.onBackgroundSB)
                        .frame(width: 28, height: 28)
                        .background(Color.backgroundSB)
                        .clipShape(Circle())
                }

                Button {
                    onRemove(product)
                } label: {
                    Image(systemName: "trash")
                        .font(.footnote)
                        .foregroundColor(.errorSB)
                        .frame(width: 28, height: 28)
                        .background(Color.backgroundSB)
                        .clipShape(Circle())
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.base)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
