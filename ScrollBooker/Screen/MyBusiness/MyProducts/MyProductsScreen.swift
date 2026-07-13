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
    
    // Forțăm explicit tipul opțional Hashable pentru poziția de scroll
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
                    withAnimation(.easeInOut) {
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
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(serviceGroups, id: \.service.id) { group in
                    // Extragem toată logica complexă a unui grup într-o funcție dedicată
                    serviceSectionRow(group: group)
                }
            }
            .padding(16)
            .scrollTargetLayout()
        }
        .scrollPosition(id: $activeSectionId, anchor: .top)
    }
    
    @ViewBuilder
    private func serviceSectionRow(group: BusinessServicesWithProducts) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(group.service.name)
                .font(.title2)
                .bold()
                .foregroundColor(.onBackgroundSB)
                .padding(.top, 12)
                .padding(.bottom, .base)
        }
        .id(group.service.id)
        
        if group.products.isEmpty {
            Text("Nu au fost găsite servicii pentru această categorie.")
                .font(.body)
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
                        .padding(.vertical, .base)
                }
            }
        }
    }
}
