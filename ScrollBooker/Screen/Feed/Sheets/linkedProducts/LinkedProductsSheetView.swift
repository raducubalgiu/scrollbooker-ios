//
//  LinkedProductsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct LinkedProductsSheetView: View {
    let viewModel: LinkedProductsViewModel
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                        
                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
                        Task { await viewModel.loadLinkedProducts() }
                    }
                        
                case .success(let products):
                    LinkedProductsSuccessView(
                        products: products,
                        onNavigateToBooking: onNavigateToBooking
                    )
                }
            }
            .navigationTitle(String(localized: "recommendedServices"))
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadLinkedProducts()
            }
        }
    }
}


