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
                    if bookingFlow.products.totalCount == 0 {
                        NoDataView(
                            title: String(localized: "services"),
                            message: String(localized: "message_empty_services"),
                            systemImage: "bag.badge.questionmark"
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        if let rebookingInfoMessage = viewModel.rebookingInfoMessage {
                            HStack(alignment: .top, spacing: AppSize.s.rawValue) {
                                Image(systemName: "info.circle")
                                Text(rebookingInfoMessage)
                                    .font(.footnote)
                            }
                            .foregroundColor(.onBackgroundSB)
                            .padding(.base)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surfaceSB)
                        }

                        ProductsList(
                            userProducts: bookingFlow.products,
                            activeSectionId: $activeSectionId,
                            isSelectable: true,
                            selectedProductIds: Set(viewModel.selectedBookingItems.map(\.productId)),
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
        }
        .task {
            await viewModel.loadBookingFlow()
            await viewModel.processInitialSelectionIfNeeded()
        }
        .onChange(of: viewModel.productPendingVariantSelection) { _, newValue in
            if let newValue {
                selectedProductForVariants = newValue
            }
        }
        .onChange(of: viewModel.scrollToSectionId) { _, newValue in
            if let newValue {
                withAnimation(.easeInOut(duration: 0.25)) {
                    activeSectionId = newValue
                }
            }
        }
        .sheet(item: $selectedProductForVariants) { product in
            ProductDetailSheetView(
                product: product,
                selectedBookingItems: viewModel.selectedBookingItems,
                onAdd: { bookingItem in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.selectBookingItem(bookingItem)
                    }
                    selectedProductForVariants = nil
                },
                onClose: { selectedProductForVariants = nil }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}


