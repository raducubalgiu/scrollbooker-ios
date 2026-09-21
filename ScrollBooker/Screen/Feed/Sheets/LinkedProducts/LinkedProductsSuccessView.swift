//
//  LinkedProductsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.07.2026.
//

import SwiftUI

struct LinkedProductsSuccessView: View {
    let linkedProducts: LinkedProducts
    let bookingSource: BookingSourceEnum
    let onNavigateToBooking: (BookingNavigationParams) -> Void

    @Environment(\.dismiss) private var dismiss

    private var products: [Product] { linkedProducts.products }

    var body: some View {
        if products.isEmpty {
            NoDataView(
                title: String(localized: "services"),
                message: String(localized: "message_empty_services"),
                systemImage: "bag.badge.questionmark"
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    LinkedProductsBusinessHeaderView(business: linkedProducts.business)

                    Text(String(localized: "recommendedServices"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.onBackgroundSB)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ForEach(products, id: \.id) { product in
                        ProductCardView(
                            product: product,
                            shouldToggleDescription: true,
                            onOpenProductDetail: { _ in },
                            onNavigateToBooking: { clickedProduct in
                                dismiss()

                                onNavigateToBooking(
                                    BookingNavigationParams(
                                        businessId: clickedProduct.businessId,
                                        userId: clickedProduct.targetUserId,
                                        businessOwnerId: clickedProduct.businessOwnerId,
                                        source: bookingSource,
                                        selectedProductId: clickedProduct.id
                                    )
                                )
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
