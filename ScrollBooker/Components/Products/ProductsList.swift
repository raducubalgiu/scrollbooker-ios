//
//  ProductsList.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductsList: View {
    let userProducts: UserProducts
    @Binding var activeSectionId: Int?
    
    var isSelectable: Bool = false
    var selectedBookingItems: [SelectedBookingItem] = []
    var isLoadingDelete: Bool = false
    
    var onOpenProductDetail: (Product) -> Void
    var onSelect: ((Product) -> Void)? = nil
    var onNavigateEditProduct: ((_ serviceId: Int, _ productId: Int) -> Void)? = nil
    
    var body: some View {
        let selectedProductIds = Set(selectedBookingItems.map { $0.productId })
        
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ProductsTabsView(
                    activeSectionId: $activeSectionId,
                    serviceGroups: userProducts.data,
                    proxy: proxy
                )
                
                ProductsScrollView(
                    serviceGroups: userProducts.data,
                    activeSectionId: $activeSectionId,
                    isSelectable: isSelectable,
                    selectedProductIds: selectedProductIds,
                    isLoadingDelete: isLoadingDelete,
                    onOpenProductDetail: onOpenProductDetail,
                    onSelect: onSelect,
                    onNavigateEditProduct: onNavigateEditProduct
                )
            }
        }
    }
}
