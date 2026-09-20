//
//  ProductCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    var displayEditableActions: Bool = false
    var shouldToggleDescription: Bool = false
    var isSelected: Bool = false
    var isSelectable: Bool = false
    var isLoadingDelete: Bool = false

    var onOpenProductDetail: (Product) -> Void
    var onSelect: ((Product) -> Void)? = nil
    var onNavigateToEdit: ((Int) -> Void)? = nil
    var onNavigateToBooking: ((Product) -> Void)? = nil
    var onDeleteProduct: ((Int) -> Void)? = nil

    @State private var isDescriptionExpanded = false

    private var productSummaryText: String {
        let duration = product.getDurationText(minutes: product.startingOffering.duration)
        let filters = product.getFiltersSummary()
        
        if filters.isEmpty {
            return duration
        } else {
            return "\(duration) • \(filters)"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(product.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(2)

                    Spacer().frame(height: 4)

                    Text(productSummaryText)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    Spacer().frame(height: 6)
                    
                    ProductCardRowPriceView(
                        hasDifferentOfferings: product.hasDifferentPrices,
                        price: product.startingOffering.price,
                        priceWithDiscount: product.startingOffering.priceWithDiscount,
                        discount: product.startingOffering.discount
                    )
                }
                
                ProductCardActionsView(
                    product: product,
                    isSelected: isSelected,
                    isSelectable: isSelectable,
                    displayEditableActions: displayEditableActions,
                    isLoadingDelete: isLoadingDelete,
                    onSelect: onSelect,
                    onNavigateToEdit: onNavigateToEdit,
                    onDeleteProduct: onDeleteProduct,
                    onNavigateToBooking: onNavigateToBooking
                )
            }
            
            if let description = product.description, !description.isEmpty {
                Spacer().frame(height: 16)

                if shouldToggleDescription {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(isDescriptionExpanded ? nil : 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isDescriptionExpanded.toggle()
                            }
                        }
                } else {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, .base)
        .contentShape(Rectangle())
        .onTapGesture {
            onOpenProductDetail(product)
        }
    }
}
