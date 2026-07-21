//
//  ProductSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductsSectionView: View {
    let group: BusinessServicesWithProducts
    let isSelectable: Bool
    let selectedProductIds: Set<Int>
    var isLoadingDelete: Bool
    
    var onOpenProductDetail: (Product) -> Void
    var onSelect: ((Product) -> Void)? = nil
    var onNavigateEditProduct: ((_ serviceId: Int, _ productId: Int) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(group.service.name)
                .font(.title2)
                .bold()
                .foregroundColor(.onBackgroundSB)
                .padding(.top, .base)
            
            if group.products.isEmpty {
                Text("Nu au fost găsite servicii pentru această categorie.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, .base)
            } else {
                ForEach(group.products, id: \.id) { product in
                    let isSelected = selectedProductIds.contains(product.id)
                    
                    ProductCardView(
                        product: product,
                        displayEditableActions: onNavigateEditProduct != nil,
                        isSelected: isSelected,
                        isSelectable: isSelectable,
                        isLoadingDelete: isLoadingDelete,
                        onOpenProductDetail: onOpenProductDetail,
                        onSelect: onSelect,
                        onNavigateToEdit: { productId in
                            onNavigateEditProduct?(group.service.id, productId)
                        }
                    )
                    
                    if group.products.last?.id != product.id {
                        Divider().background(Color.dividerSB)
                    }
                }
            }
        }
    }
}
