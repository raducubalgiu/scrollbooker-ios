//
//  SearchScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import MapKit

enum SearchSheetType: Identifiable {
    case services
    case filters
    
    var id: Self { self }
}

struct SearchScreen: View {
    var viewModel: SearchViewModel
    var onNavigateToBusinessProfile: (String) -> Void

    @State private var isLoading: Bool = true
    @State private var activeSheet: SearchSheetType? = nil
    
    private let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4268, longitude: 26.1025),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4268, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
    )

    var body: some View {
        ZStack(alignment: .top) {
            if isLoading {
                Color.surfaceSB.ignoresSafeArea(.all, edges: .top)
            } else {
                SearchMapView(
                    markers: viewModel.markers,
                    cameraPosition: $cameraPosition,
                    onRegionChange: { bbox, zoom in
                        Task { await viewModel.triggerSearch(bbox: bbox, zoom: zoom) }
                    }
                )
            }

            VStack(spacing: 0) {
                SearchHeaderView(
                    onServicesTap: { activeSheet = .services },
                    onFiltersTap: { activeSheet = .filters }
                )
                .padding(.horizontal, .base)
                .padding(.bottom, 12)
                
                ZStack(alignment: .top) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CategoryFilterButton(
                                title: String(localized: "all"),
                                isSelected: viewModel.filters.businessDomainId == nil,
                                action: { selectDomain(id: nil) }
                            )
                            
                            ForEach(viewModel.businessDomains, id: \.id) { domain in
                                CategoryFilterButton(
                                    title: domain.shortName,
                                    isSelected: viewModel.filters.businessDomainId == domain.id,
                                    action: { selectDomain(id: domain.id) }
                                )
                            }
                        }
                        .padding(.horizontal, .base)
                        .padding(.bottom, 6)
                    }
                    .zIndex(1)
                    
                    Color.clear
                        .frame(height: 40)
                        .overlay(alignment: .top) {
                            if viewModel.isInitialLoading && !isLoading {
                                SearchMapLoading()
                                    .padding(.top, 48)
                                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                            }
                        }
                        .zIndex(2)

                    SearchSheetContainerView(
                        isLoading: viewModel.isInitialLoading,
                        isPaging: viewModel.isPaging,
                        businesses: viewModel.businesses,
                        totalCount: viewModel.totalCount,
                        onNavigateToBusinessProfile: onNavigateToBusinessProfile,
                        onSelectProduct: { productId in print("Produs selectat: \(productId)") },
                        onLoadMore: { business in
                            Task { await viewModel.loadMoreIfNeeded(currentBusiness: business) }
                        }
                    )
                    .zIndex(3)
                }
            }
        }
        .task {
            let bbox = BusinessBoundingBox(
                minLng: Float(initialRegion.center.longitude - initialRegion.span.longitudeDelta / 2),
                maxLng: Float(initialRegion.center.longitude + initialRegion.span.longitudeDelta / 2),
                minLat: Float(initialRegion.center.latitude - initialRegion.span.latitudeDelta / 2),
                maxLat: Float(initialRegion.center.latitude + initialRegion.span.latitudeDelta / 2)
            )

            await viewModel.initializeScreen(bbox: bbox, zoom: 10.0)
            
            withAnimation(.easeInOut(duration: 0.25)) {
                isLoading = false
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .services:
                SearchServicesSheet(
                    viewModel: viewModel,
                    onClose: { activeSheet = nil },
                    onFilter: { updatedFilters in
                        viewModel.filters = updatedFilters
                        activeSheet = nil
                        
                        if let bbox = viewModel.currentBBox {
                            Task {
                                await viewModel.triggerSearch(
                                    bbox: bbox,
                                    zoom: viewModel.currentZoom,
                                    force: true
                                )
                            }
                        }
                    }
                )
                .presentationDetents([.large])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
            case .filters:
                SearchFiltersSheet(
                    viewModel: viewModel,
                    onClose: { activeSheet = nil },
                    onFilter: { updatedFilters in
                        viewModel.filters = updatedFilters
                        activeSheet = nil
                        
                        if let bbox = viewModel.currentBBox {
                            Task {
                                await viewModel.triggerSearch(
                                    bbox: bbox,
                                    zoom: viewModel.currentZoom,
                                    force: true
                                )
                            }
                        }
                    }
                )
                .presentationDetents([.large])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
            }
        }
    }
    
    private func selectDomain(id: Int?) {
        viewModel.filters.businessDomainId = id
        
        if let bbox = viewModel.currentBBox {
            Task {
                await viewModel.triggerSearch(
                    bbox: bbox,
                    zoom: viewModel.currentZoom,
                    force: true
                )
            }
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.primary : Color(.systemBackground))
                .foregroundColor(isSelected ? Color(.systemBackground) : .primary)
                .cornerRadius(20)
                .shadow(
                    color: Color.black.opacity(isSelected ? 0.12 : 0.08),
                    radius: 6,
                    x: 0,
                    y: 3
                )
        }
    }
}
