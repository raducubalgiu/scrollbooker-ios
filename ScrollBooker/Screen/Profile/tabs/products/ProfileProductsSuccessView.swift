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

    @State private var selectedTab: Int = 0

    private var serviceGroups: [BusinessServicesWithProducts] { products.data }

    private var selectedGroupProducts: [Product] {
        guard serviceGroups.indices.contains(selectedTab) else { return [] }
        return serviceGroups[selectedTab].products
    }

    // Same heuristic as Android's ProfileProductsTab: each tab only previews a handful
    // of products per service, so once the real total outgrows that preview, offer a
    // way to see everything instead of silently truncating.
    private var shouldShowViewMore: Bool {
        (serviceGroups.count * 5) < products.totalCount
    }

    var body: some View {
        VStack(spacing: 0) {
            PillTabBarView(
                tabs: serviceGroups.map { $0.service.shortName },
                selectedTab: $selectedTab
            )

            Divider()

            LazyVStack(spacing: 0) {
                ForEach(Array(selectedGroupProducts.enumerated()), id: \.element.id) { index, product in
                    ProductCardView(
                        product: product,
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
            .id(selectedTab)
        }
    }
}
