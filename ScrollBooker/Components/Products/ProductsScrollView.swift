//
//  ProductsScrollView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductsScrollView: View {
    let serviceGroups: [BusinessServicesWithProducts]
    @Binding var activeSectionId: Int?
    
    let isSelectable: Bool
    let selectedProductIds: Set<Int>
    var isLoadingDelete: Bool
    
    var onOpenProductDetail: (Product) -> Void
    var onSelect: ((Product) -> Void)? = nil
    var onNavigateEditProduct: ((_ serviceId: Int, _ productId: Int) -> Void)? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(serviceGroups, id: \.service.id) { group in
                    ProductsSectionView(
                        group: group,
                        isSelectable: isSelectable,
                        selectedProductIds: selectedProductIds,
                        isLoadingDelete: isLoadingDelete,
                        onOpenProductDetail: onOpenProductDetail,
                        onSelect: onSelect,
                        onNavigateEditProduct: onNavigateEditProduct
                    )
                    .id(group.service.id)
                }
            }
            .padding(.horizontal, 16)
            .scrollTargetLayout()
        }
        .scrollPosition(id: $activeSectionId, anchor: .top)
    }
}
