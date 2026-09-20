//
//  ProductDetailSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductDetailSheetView: View {
    let product: Product
    var selectedBookingItems: [SelectedBookingItem] = []
    var onAdd: (SelectedBookingItem) -> Void
    var onClose: () -> Void

    @State private var selectedVariant: ProductVariant?

    private var alreadySelectedItem: SelectedBookingItem? {
        selectedBookingItems.first { $0.productId == product.id }
    }

    private var isButtonEnabled: Bool {
        let isCurrentVariantAlreadyInCart = alreadySelectedItem != nil && alreadySelectedItem?.variantId == selectedVariant?.id

        if isCurrentVariantAlreadyInCart { return false }
        if product.variants.count == 1 { return true }
        return selectedVariant != nil
    }

    private var buttonText: String {
        if let alreadySelectedItem, selectedVariant?.id != alreadySelectedItem.variantId {
            return String(localized: "update")
        } else if alreadySelectedItem != nil {
            return String(localized: "added")
        } else {
            return String(localized: "add")
        }
    }

    private var displayedPriceWithDiscount: Decimal {
        selectedVariant?.startingOffering.priceWithDiscount ?? product.startingOffering.priceWithDiscount
    }

    private var hasMultiplePrices: Bool {
        selectedVariant?.hasDifferentPrices ?? product.hasDifferentPrices
    }

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose)

            ScrollView {
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    ProductDetailInfoView(name: product.name, description: product.description)

                    ProductDetailFiltersView(filters: product.filters)

                    ProductDetailVariantsView(
                        product: product,
                        variants: product.variants,
                        selectedVariant: selectedVariant,
                        onSelectVariant: { selectedVariant = $0 }
                    )
                }
                .padding(.vertical, .base)
            }

            ProductDetailBottomBarView(
                buttonText: buttonText,
                showFromPrefix: hasMultiplePrices,
                priceWithDiscount: displayedPriceWithDiscount,
                durationText: product.getDurationText(minutes: selectedVariant?.duration ?? product.startingOffering.duration),
                isEnabled: isButtonEnabled,
                onAddBookingItem: {
                    let targetVariant = selectedVariant ?? product.variants.first
                    guard let targetVariant else { return }
                    onAdd(targetVariant.toBookingItem(product: product))
                }
            )
        }
        .onAppear {
            if let alreadySelectedItem {
                selectedVariant = product.variants.first { $0.id == alreadySelectedItem.variantId }
            } else if product.variants.count == 1 {
                selectedVariant = product.variants.first
            }
        }
    }
}
