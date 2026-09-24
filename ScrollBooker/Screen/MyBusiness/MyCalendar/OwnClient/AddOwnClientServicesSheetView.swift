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
    var onConfirm: ([SelectedBookingItem]) -> Void
    var onClose: () -> Void
    var onRetry: () -> Void

    @State private var localLinkedItems: [SelectedBookingItem]
    @State private var activeSectionId: Int?
    @State private var selectedProductForVariants: Product?

    init(
        userProductsState: FeatureState<UserProducts>,
        linkedItems: [SelectedBookingItem],
        onConfirm: @escaping ([SelectedBookingItem]) -> Void,
        onClose: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) {
        self.userProductsState = userProductsState
        self.linkedItems = linkedItems
        self.onConfirm = onConfirm
        self.onClose = onClose
        self.onRetry = onRetry
        self._localLinkedItems = State(initialValue: linkedItems)
    }

    private var isConfirmEnabled: Bool { localLinkedItems != linkedItems }

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
                            selectedProductIds: Set(localLinkedItems.map(\.productId)),
                            onOpenProductDetail: { product in selectedProductForVariants = product },
                            onSelect: { product in
                                if let existing = localLinkedItems.first(where: { $0.productId == product.id }) {
                                    localLinkedItems.removeAll { $0.productId == existing.productId }
                                } else if product.variants.count > 1 {
                                    selectedProductForVariants = product
                                } else if let firstVariant = product.variants.first {
                                    localLinkedItems.append(firstVariant.toBookingItem(product: product))
                                }
                            },
                            onNavigateEditProduct: nil
                        )
                    }
            }

            Divider()

            MainButton(
                title: String(localized: "add"),
                isDisabled: !isConfirmEnabled,
                isLoading: false,
                onClick: {
                    onConfirm(localLinkedItems)
                }
            )
            .padding(.base)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(item: $selectedProductForVariants) { product in
            ProductDetailSheetView(
                product: product,
                selectedBookingItems: localLinkedItems,
                onAdd: { bookingItem in
                    localLinkedItems.removeAll { $0.productId == bookingItem.productId }
                    localLinkedItems.append(bookingItem)
                    selectedProductForVariants = nil
                },
                onClose: { selectedProductForVariants = nil }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
