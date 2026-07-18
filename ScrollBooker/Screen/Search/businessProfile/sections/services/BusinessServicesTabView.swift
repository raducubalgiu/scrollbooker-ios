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

    @State private var currentPage: Int = 0
    
    var body: some View {
        let serviceGroups = products.data
        let totalCount = products.totalCount
        
        VStack(alignment: .leading, spacing: 0) {
            
            if !serviceGroups.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSize.s.rawValue) {
                        ForEach(Array(serviceGroups.enumerated()), id: \.element.service.id) { index, group in
                            let isSelected = currentPage == index
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    currentPage = index
                                }
                            }) {
                                Text(group.service.shortName)
                                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? .onSurfaceSB : .onBackgroundSB)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .frame(height: 42)
                                    .background(isSelected ? Color.surfaceSB : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, .base)
                }
                .padding(.bottom, .s)
                
                Divider().padding(.horizontal, .base)
                
                if currentPage < serviceGroups.count {
                    let currentGroup = serviceGroups[currentPage]
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(currentGroup.products) { product in
                            ProductCard(
                                product: product,
                                displayDescription: false,
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
