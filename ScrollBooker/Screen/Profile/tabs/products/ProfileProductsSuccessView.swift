//
//  ProfileProductsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct ProfileProductsSuccessView: View {
    let products: UserProducts
    let onNavigateToBookingFromProduct: (Product) -> Void

    @State private var activeSectionId: Int? = nil

    private var serviceGroups: [BusinessServicesWithProducts] { products.data }

    private var selectedGroupProducts: [Product] {
        serviceGroups.first { $0.service.id == (activeSectionId ?? serviceGroups.first?.service.id) }?.products ?? []
    }

    private var shouldShowViewMore: Bool {
        (serviceGroups.count * 5) < products.totalCount
    }

    var body: some View {
        VStack(spacing: 0) {
            BookingServicesTabs(
                activeSectionId: activeSectionId ?? serviceGroups.first?.service.id ?? 0,
                serviceGroups: serviceGroups,
                onTabSelect: { activeSectionId = $0 }
            )

            Divider()

            LazyVStack(spacing: 0) {
                ForEach(Array(selectedGroupProducts.enumerated()), id: \.element.id) { index, product in
                    ProductCardView(
                        product: product,
                        shouldToggleDescription: true,
                        onOpenProductDetail: { _ in },
                        onNavigateToBooking: onNavigateToBookingFromProduct
                    )
                    .padding(.horizontal, .base)

                    if index < selectedGroupProducts.count - 1 {
                        Divider()
                            .padding(.horizontal, .base)
                    }
                }

                if shouldShowViewMore {
                    MainButtonOutlined(
                        title: String(format: String(localized: "profile_products_view_more"), products.totalCount),
                        fullWidth: true
                    ) {}
                    .padding(.base)
                }
            }
            .padding(.vertical, .base)
            .id(activeSectionId)
        }
    }
}
