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
            }
            
            switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadProducts() }
                    }
                
                case .success(let userProducts):
                    ProductsList(
                        userProducts: userProducts,
                        activeSectionId: $activeSectionId,
                        onOpenProductDetail: { _ in }
                    )
                }
        }
        .task {
            await viewModel.loadProducts()
        }
    }
}



