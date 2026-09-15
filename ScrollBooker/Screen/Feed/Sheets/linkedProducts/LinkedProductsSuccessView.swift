//
//  LinkedProductsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.07.2026.
//

import SwiftUI

struct LinkedProductsSuccessView: View {
    let products: [Product]
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if products.isEmpty {
            NoDataView(
                title: String(localized: "services"),
                message: String(localized: "postNoLinkedProducts"),
                systemImage: "bag.badge.questionmark"
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(products, id: \.id) { product in
                        ProductCardView(
                            product: product,
                            onOpenProductDetail: { _ in },
                            onNavigateToBooking: { clickedProduct in
                                dismiss()
                                
                                onNavigateToBooking(
                                    BookingNavigationParams(
                                        businessId: clickedProduct.businessId,
                                        userId: clickedProduct.targetUserId,
                                        businessOwnerId: clickedProduct.businessOwnerId,
                                        source: BookingSourceEnum.exploreFeed,
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
