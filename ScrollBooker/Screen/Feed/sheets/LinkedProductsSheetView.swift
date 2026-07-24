//
//  LinkedProductsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct LinkedProductsSheetView: View {
    let viewModel: LinkedProductsViewModel
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                        
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadLinkedProducts() }
                    }
                        
                case .success(let products):
                    if products.isEmpty {
                        NoDataView(
                            title: "Servicii",
                            message: "Această postare nu are servicii atașate.",
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
            .navigationTitle("Servicii recomandate")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadLinkedProducts()
            }
        }
    }
}
