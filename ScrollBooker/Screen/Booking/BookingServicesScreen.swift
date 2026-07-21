//
//  BookingServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI
public struct BookingServicesScreen: View {
    @State var viewModel: BookingViewModel
    let onBack: () -> Void
    let onNext: () -> Void
    
    @State private var activeSectionId: Int? = nil
    @State private var selectedProductForVariants: Product? = nil
    
    public var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Alege Serviciile", onBack: onBack)
            
            switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadBookingFlow() }
                    }
                    
                case .success(let bookingFlow):
                    ProductsList(
                        userProducts: bookingFlow.products,
                        activeSectionId: $activeSectionId,
                        isSelectable: true,
                        selectedBookingItems: viewModel.selectedBookingItems,
                        onOpenProductDetail: { product in selectedProductForVariants = product },
                        onSelect: { product in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                if let existingSelectedItem = viewModel.selectedBookingItems.first(where: { $0.productId == product.id }) {
                                    viewModel.selectBookingItem(existingSelectedItem)
                                } else {
                                    if product.variants.count > 1 {
                                        selectedProductForVariants = product
                                    } else if let firstVariant = product.variants.first {
                                        let bookingItem = firstVariant.toBookingItem(product: product)
                                        viewModel.selectBookingItem(bookingItem)
                                    }
                                }
                            }
                        },
                        onNavigateEditProduct: nil
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        BookingBottomBar(
                            bookingTotals: viewModel.bookingTotals,
                            onNext: onNext,
                            isEnabled: !viewModel.selectedBookingItems.isEmpty,
                            isVisible: !viewModel.selectedBookingItems.isEmpty
                        )
                    }
                }
        }
        .task {
            await viewModel.loadBookingFlow()
        }
        .sheet(item: $selectedProductForVariants) { product in
            ProductDetailSheetView(product: product) { selectedVariant in
                withAnimation(.easeInOut(duration: 0.25)) {
                    let bookingItem = selectedVariant.toBookingItem(product: product)
                    viewModel.selectBookingItem(bookingItem)
                }
                selectedProductForVariants = nil
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}


