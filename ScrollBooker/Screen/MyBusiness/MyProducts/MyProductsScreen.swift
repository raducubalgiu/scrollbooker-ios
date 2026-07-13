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
    var onNavigateEditProduct: (Int, Int) -> Void // serviceId, productId
    
    @State private var activeSectionId: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Serviciile mele", onBack: onBack) {
                Button(action: onNavigateAddProduct) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            }
            
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    loadingView
                    
                case .error(let message):
                    errorView(message: message)
                    
                case .success(let userProducts):
                    successContent(userProducts: userProducts)
                }
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }
    
    // MARK: - Sub-Views (@ViewBuilder)
    
    @ViewBuilder
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Reîncearcă") {
                Task { await viewModel.loadProducts() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func successContent(userProducts: UserProducts) -> some View {
        let serviceGroups = userProducts.data
        let fallbackId = serviceGroups.first?.service.id ?? 0
        
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                BookingServicesTabs(
                    activeSectionId: activeSectionId ?? fallbackId,
                    serviceGroups: serviceGroups
                ) { clickedTabId in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        activeSectionId = clickedTabId
                        proxy.scrollTo(clickedTabId, anchor: .top)
                    }
                }
                
                productsScrollView(serviceGroups: serviceGroups)
            }
        }
    }
    
    @ViewBuilder
    private func productsScrollView(serviceGroups: [BusinessServicesWithProducts]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(serviceGroups, id: \.service.id) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        serviceSectionRow(group: group)
                    }
                    .id(group.service.id)
                }
            }
            .padding(.horizontal, 16)
            .scrollTargetLayout()
        }
        .scrollPosition(id: $activeSectionId, anchor: .top)
    }
    
    @ViewBuilder
    private func serviceSectionRow(group: BusinessServicesWithProducts) -> some View {
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
                ProductCard(
                    product: product,
                    displayEditableActions: true,
                    isLoadingDelete: false,
                    onOpenProductDetail: { _ in },
                    onNavigateToEdit: { productId in
                        onNavigateEditProduct(group.service.id, productId)
                    }
                )
                
                if group.products.last?.id != product.id {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                }
            }
        }
    }
}
