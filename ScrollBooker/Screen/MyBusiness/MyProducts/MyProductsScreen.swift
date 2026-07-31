//
//  MyProductsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyProductsScreen: View {
    @Bindable var viewModel: MyProductsViewModel
    var onBack: () -> Void
    var onNavigateAddProduct: () -> Void
    var onNavigateEditProduct: (Int, Int) -> Void
    
    @State private var activeSectionId: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Serviciile mele", onBack: onBack) {
                Button(action: onNavigateAddProduct) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                .padding(.trailing, .base)
            }
            
            switch viewModel.viewState {
            case .idle, .loading:
                LoadingView()
                
            case .error:
                ErrorView(message: String(localized: "somethingWentWrong")) {
                    Task { await viewModel.loadProducts() }
                }
            
            case .success(let userProducts):
                if userProducts.data.isEmpty {
                    NoDataView(
                        title: "Servicii",
                        message: "Nu ai adăugat încă niciun serviciu sau produs.",
                        systemImage: "bag.badge.plus"
                    )
                } else {
                    ProductsList(
                        userProducts: userProducts,
                        activeSectionId: $activeSectionId,
                        onOpenProductDetail: { _ in },
                        onNavigateEditProduct: onNavigateEditProduct
                    )
                }
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }
}



