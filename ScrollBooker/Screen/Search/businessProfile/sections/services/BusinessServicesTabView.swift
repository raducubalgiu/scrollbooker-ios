//
//  BusinessServicesTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessServicesTabView: View {
    let products: UserProducts
    let onNavigateToBookingFromProfile: () -> Void
    let onNavigateToBookingFromProduct: (Product) -> Void

    @State private var activeSectionId: Int? = nil

    var body: some View {
        let serviceGroups = products.data
        let totalCount = products.totalCount

        VStack(alignment: .leading, spacing: 0) {
            if !serviceGroups.isEmpty {
                BookingServicesTabs(
                    activeSectionId: activeSectionId ?? serviceGroups.first?.service.id ?? 0,
                    serviceGroups: serviceGroups,
                    onTabSelect: { activeSectionId = $0 }
                )

                Divider().padding(.horizontal, .base)

                if let currentGroup = serviceGroups.first(where: { $0.service.id == (activeSectionId ?? serviceGroups.first?.service.id) }) {

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(currentGroup.products) { product in
                            ProductCardView(
                                product: product,
                                shouldToggleDescription: true,
                                onOpenProductDetail: { _ in },
                                onNavigateToBooking: onNavigateToBookingFromProduct
                            )
                        }
                        
                        let shouldShowViewMore = (serviceGroups.count * 5) < totalCount
                        if shouldShowViewMore {
                            MainButtonOutlined(
                                title: "Vezi toate cele \(totalCount) servicii",
                                size: .medium,
                                fullWidth: true,
                                onClick: onNavigateToBookingFromProfile
                            )
                            .padding(.top, .base)
                        } else {
                            Divider()
                        }
                    }
                    .padding(.horizontal, .base)
                    .padding(.vertical, .s)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
                
            } else {
                Text(String(localized: "notFoundServices"))
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal, .base)
                    .padding(.vertical, .base)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
