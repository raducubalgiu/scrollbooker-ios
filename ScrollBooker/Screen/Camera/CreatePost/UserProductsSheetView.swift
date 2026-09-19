//
//  UserProductsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct UserProductsSheetView: View {
    let linkedProducts: [Product]
    let userProductsViewState: FeatureState<UserProducts>
    var onConfirmSelection: (Set<Product>) -> Void
    var onClose: () -> Void

    @State private var localLinkedProducts: Set<Product>
    @State private var activeSectionId: Int?

    init(
        linkedProducts: [Product],
        userProductsViewState: FeatureState<UserProducts>,
        onConfirmSelection: @escaping (Set<Product>) -> Void,
        onClose: @escaping () -> Void
    ) {
        self.linkedProducts = linkedProducts
        self.userProductsViewState = userProductsViewState
        self.onConfirmSelection = onConfirmSelection
        self.onClose = onClose
        self._localLinkedProducts = State(initialValue: Set(linkedProducts))
    }

    private var isConfirmEnabled: Bool {
        !localLinkedProducts.isEmpty && localLinkedProducts != Set(linkedProducts)
    }

    private var selectionCountText: String {
        let count = localLinkedProducts.count
        return count == 1 ? "\(count) produs selectat" : "\(count) produse selectate"
    }

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: onClose,
                title: String(localized: "linkedProducts")
            )

            switch userProductsViewState {
            case .idle, .loading:
                LoadingView()

            case .error:
                ErrorView(message: String(localized: "message_error_something_went_wrong")) {}

            case .success(let userProducts):
                ProductsList(
                    userProducts: userProducts,
                    activeSectionId: $activeSectionId,
                    isSelectable: true,
                    selectedProductIds: Set(localLinkedProducts.map(\.id)),
                    onOpenProductDetail: { _ in },
                    onSelect: { product in
                        if localLinkedProducts.contains(product) {
                            localLinkedProducts.remove(product)
                        } else {
                            localLinkedProducts.insert(product)
                        }
                    }
                )
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()

                HStack {
                    Text(selectionCountText)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)

                    Spacer()

                    MainButtonMini(
                        title: String(localized: "confirm"),
                        isDisabled: !isConfirmEnabled,
                        onClick: {
                            onConfirmSelection(localLinkedProducts)
                            onClose()
                        }
                    )
                }
                .padding(.base)
            }
            .background(Color.backgroundSB)
        }
    }
}
