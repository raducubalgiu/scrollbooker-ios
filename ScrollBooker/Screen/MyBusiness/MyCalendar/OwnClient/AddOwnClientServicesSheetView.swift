//
//  AddOwnClientServicesSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientServicesSheetView: View {
    let userProductsState: FeatureState<UserProducts>
    let linkedItems: [SelectedBookingItem]
    var onSelectBookingItem: (SelectedBookingItem) -> Void
    var onClose: () -> Void
    var onRetry: () -> Void

    @State private var activeSectionId: Int?
    @State private var selectedProductForVariants: Product?

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: String(localized: "addServices"), showDivider: false)

            switch userProductsState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message, retryAction: onRetry)

                case .success(let userProducts):
                    if userProducts.totalCount == 0 {
                        NoDataView(
                            title: String(localized: "services"),
                            message: String(localized: "message_empty_services"),
                            systemImage: "bag.badge.questionmark"
                        )
                    } else {
                        ProductsList(
                            userProducts: userProducts,
                            activeSectionId: $activeSectionId,
                            isSelectable: true,
                            selectedProductIds: Set(linkedItems.map(\.productId)),
                            onOpenProductDetail: { product in selectedProductForVariants = product },
                            onSelect: { product in
                                if let existingSelectedItem = linkedItems.first(where: { $0.productId == product.id }) {
                                    onSelectBookingItem(existingSelectedItem)
                                } else if product.variants.count > 1 {
                                    selectedProductForVariants = product
                                } else if let firstVariant = product.variants.first {
                                    onSelectBookingItem(firstVariant.toBookingItem(product: product))
                                }
                            },
                            onNavigateEditProduct: nil
                        )
                    }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(item: $selectedProductForVariants) { product in
            ProductDetailSheetView(
                product: product,
                selectedBookingItems: linkedItems,
                onAdd: { bookingItem in
                    onSelectBookingItem(bookingItem)
                    selectedProductForVariants = nil
                },
                onClose: { selectedProductForVariants = nil }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
