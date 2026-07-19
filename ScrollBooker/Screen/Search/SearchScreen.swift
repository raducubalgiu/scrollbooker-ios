//
//  SearchScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import MapKit

struct SearchScreen: View {
    let viewModel: SearchViewModel
    var onNavigateToBusinessProfile: (String) -> Void

    @State private var isLoading: Bool = true
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4268, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
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

            VStack(spacing: 12) {
                SearchHeaderView()
                    .padding(.horizontal, .base)

                if viewModel.isInitialLoading && !isLoading {
                    SearchMapLoading()
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }

                SearchSheetContainerView(
                    isLoading: viewModel.isInitialLoading,
                    isPaging: viewModel.isPaging,
                    businesses: viewModel.businesses,
                    totalCount: viewModel.totalCount,
                    onNavigateToBusinessProfile: onNavigateToBusinessProfile,
                    onSelectProduct: { productId in
                        print("Produs selectat: \(productId)")
                    },
                    onLoadMore: { business in
                        Task { await viewModel.loadMoreIfNeeded(currentBusiness: business) }
                    }
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.25)) {
                isLoading = false
            }
        }
    }
}
