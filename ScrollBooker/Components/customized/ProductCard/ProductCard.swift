//
//  ProductCard.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    var displayEditableActions: Bool = false
    var displayDescription: Bool = true
    var isSelected: Bool = false
    var isSelectable: Bool = false
    var isLoadingDelete: Bool = false
    
    var onOpenProductDetail: (Product) -> Void
    var onSelect: ((Product) -> Void)? = nil
    var onNavigateToEdit: ((Int) -> Void)? = nil
    var onNavigateToBooking: ((Product) -> Void)? = nil
    var onDeleteProduct: ((Int) -> Void)? = nil
    
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
            if !product.filters.isEmpty && product.type == .pack && product.sessionsCount != nil {
                //ProductPackageBadge(sessionsCount = product.sessionsCount)
                Spacer().frame(height: 16)
            }
            
            HStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(product.name)
                        .font(.subheadline.bold())
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(2)
                    
                    Spacer().frame(height: 4)
                    
                    Text(productSummaryText)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    Spacer().frame(height: 6)
                    
                    ProductCardRowPrice(
                        price: product.startingOffering.price,
                        priceWithDiscount: product.startingOffering.priceWithDiscount,
                        discount: product.startingOffering.discount
                    )
                }
                
//                ProductCardActions(
//                    product: product,
//                    isSelected: isSelected,
//                    isSelectable: isSelectable,
//                    displayEditableActions: displayEditableActions,
//                    isLoadingDelete: isLoadingDelete,
//                    onSelect: onSelect,
//                    onNavigateToEdit: onNavigateToEdit,
//                    onDeleteProduct: onDeleteProduct,
//                    onNavigateToBooking: onNavigateToBooking
//                )
            }
            
            if let description = product.description, !description.isEmpty && displayDescription {
                Spacer().frame(height: 16)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            if !product.canBeBooked {
                Spacer().frame(height: 16)
                
                Text("Acest serviciu poate fi rezervat doar în urma unei discuții telefonice")
                    .font(.footnote)
                    .foregroundColor(.errorSB)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onOpenProductDetail(product)
        }
    }
}
