//
//  SearchScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import MapKit

enum SheetPosition {
    case collapsed
    case expanded
}

struct LastCameraState {
    let center: CLLocationCoordinate2D
    let zoom: Float
}

struct SearchScreen: View {
    let viewModel: SearchViewModel
    var onNavigateToBusinessProfile: (String) -> Void
    
    @State private var sheetPosition: SheetPosition = .collapsed
    @State private var dragOffset: CGFloat = 0
    @State private var isLoading: Bool = true
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.4268, longitude: 26.1025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    private let headerHeight: CGFloat = 56
    private let headerBottomPadding: CGFloat = 12
    private let collapsedHeight: CGFloat = 160
    
    @State private var lastRequestedState: LastCameraState? = nil
    @State private var mapViewportWidth: CGFloat = 0
    @State private var lastSearchTask: Task<Void, Never>? = nil

    private let minZoomDelta: Float = 0.5
    private let minMoveMeters: Double = 10000.0
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack(alignment: .top) {
            if isLoading {
                Color.surfaceSB.ignoresSafeArea(.all, edges: .top)
            } else {
                mapViewSection(viewModel: viewModel)
            }
            
            VStack(spacing: headerBottomPadding) {
                SearchHeaderView()
                    .padding(.horizontal, .base)
                
                if viewModel.isLoading && !isLoading {
                    SearchMapLoading()
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }
                
                GeometryReader { geometry in
                    let totalHeight = geometry.size.height
                    let sheetMaxHeight = max(0, totalHeight)
                    
                    let currentOffset: CGFloat = {
                        guard totalHeight > 0 else { return 600 }
                        
                        switch sheetPosition {
                        case .collapsed:
                            return totalHeight - collapsedHeight + headerHeight + headerBottomPadding
                        case .expanded:
                            return 0
                        }
                    }()
                    
                    AirbnbBottomSheet(
                        maxHeight: sheetMaxHeight,
                        isLoading: viewModel.isLoading,
                        businesses: viewModel.businesses,
                        onNavigateToBusinessProfile: { id in
                            onNavigateToBusinessProfile(id)
                        },
                        onSelectProduct: { product in
                            print("Produs selectat: \(product)")
                        }
                    )
                    .offset(y: max(0, currentOffset + dragOffset))
                    .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.85, blendDuration: 0), value: dragOffset)
                    .animation(.spring(response: 0.4, dampingFraction: 0.85), value: sheetPosition)
                    .gesture(
                        DragGesture(minimumDistance: 5)
                            .onChanged { value in
                                let horizontalDistance = abs(value.translation.width)
                                let verticalDistance = abs(value.translation.height)
                                guard verticalDistance > horizontalDistance else { return }
                                
                                let proposedOffset = value.translation.height
                                
                                if sheetPosition == .expanded {
                                    if proposedOffset < 0 {
                                        dragOffset = proposedOffset * 0.15
                                    } else {
                                        dragOffset = proposedOffset
                                    }
                                } else if sheetPosition == .collapsed {
                                    if proposedOffset > 0 {
                                        dragOffset = proposedOffset * 0.1
                                    } else {
                                        dragOffset = proposedOffset
                                    }
                                }
                            }
                            .onEnded { value in
                                let horizontalDistance = abs(value.translation.width)
                                let verticalDistance = abs(value.translation.height)
                                
                                guard verticalDistance > horizontalDistance else {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                        dragOffset = 0
                                    }
                                    return
                                }
                                
                                let velocity = value.predictedEndTranslation.height
                                
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    if velocity < -100 {
                                        sheetPosition = .expanded
                                    } else if velocity > 100 {
                                        sheetPosition = .collapsed
                                    } else {
                                        if value.translation.height < -60 {
                                            sheetPosition = .expanded
                                        } else {
                                            sheetPosition = .collapsed
                                        }
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
                }
            }
        }
        .onAppear {
            Task {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isLoading = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func mapViewSection(viewModel: SearchViewModel) -> some View {
        let markers = viewModel.markers
        let bottomMarkers = markers.filter { !$0.isPrimary }
        let topMarkers = markers.filter { $0.isPrimary }
        
        GeometryReader { geo in
            Map(position: $cameraPosition) {
                ForEach(bottomMarkers) { m in
                    Annotation(m.owner.fullName, coordinate: m.clCoordinates, anchor: .center) {
                        SearchMarkerSecondary(color: m.businessShortDomain.domainColor)
                            .id("\(m.id)_secondary")
                            .drawingGroup()
                            .onTapGesture {
                                
                            }
                    }
                }
                
                ForEach(topMarkers) { m in
                    Annotation(m.owner.fullName, coordinate: m.clCoordinates, anchor: .bottom) {
                        SearchMarkerPrimary(
                            imageUrl: m.mediaFiles.first??.thumbnailUrl,
                            domainColor: m.businessShortDomain.domainColor
                        )
                        .id("\(m.id)_primary")
                        .drawingGroup()
                        .onTapGesture {
                            
                        }
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .onAppear {
                mapViewportWidth = geo.size.width
            }
            .onChange(of: geo.size.width) { _, newValue in
                mapViewportWidth = newValue
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                handleCameraChange(context: context)
            }
        }
    }

    private func handleCameraChange(context: MapCameraUpdateContext) {
        let region = context.region
        let spanLng = region.span.longitudeDelta
        let spanLat = region.span.latitudeDelta
        let center = region.center
        
        let minLat = center.latitude - (spanLat / 2)
        let maxLat = center.latitude + (spanLat / 2)
        let minLng = center.longitude - (spanLng / 2)
        let maxLng = center.longitude + (spanLng / 2)
        
        let bbox = BusinessBoundingBox(
            minLng: Float(minLng),
            maxLng: Float(maxLng),
            minLat: Float(minLat),
            maxLat: Float(maxLat)
        )
        
        var currentZoom: Float = 10.0
        
        if spanLng > 0, mapViewportWidth > 0 {
            let rawZoom = log2(Double(mapViewportWidth) * 360.0 / (spanLng * 256.0))
            
            if rawZoom.isFinite {
                currentZoom = max(1.0, min(20.0, Float(rawZoom)))
            }
        }
        
        guard shouldTriggerNewSearch(center: center, zoom: currentZoom) else { return }
        lastRequestedState = LastCameraState(center: center, zoom: currentZoom)
        
        lastSearchTask?.cancel()
        lastSearchTask = Task {
            await viewModel.triggerSearch(bbox: bbox, zoom: currentZoom)
        }
    }
    
    private func shouldTriggerNewSearch(center: CLLocationCoordinate2D, zoom: Float) -> Bool {
        guard let last = lastRequestedState else { return true }
        
        if abs(last.zoom - zoom) >= minZoomDelta {
            return true
        }
        
        let lastLocation = CLLocation(latitude: last.center.latitude, longitude: last.center.longitude)
        let newLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        return lastLocation.distance(from: newLocation) >= minMoveMeters
    }
}



struct AirbnbBottomSheet: View {
    let maxHeight: CGFloat
    let isLoading: Bool
    let businesses: [BusinessSheet]
    
    var onNavigateToBusinessProfile: (String) -> Void
    var onSelectProduct: (String) -> Void
    
    @State private var pulseSkeleton = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.primary.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 10)
                
                VStack(alignment: .center, spacing: 4) {
                    Text("Explorează în apropiere")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(isLoading ? "Se caută rezultate..." : "\(businesses.count) de rezultate găsite")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 18) {
                    if isLoading {
                        ForEach(1...3, id: \.self) { _ in
                            SearchCardSkeletonView(isAnimating: pulseSkeleton)
                        }
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                                pulseSkeleton = true
                            }
                        }
                    } else {
                        ForEach(businesses, id: \.id) { business in
                            SearchCardView(
                                business: business,
                                onNavigateToBusinessProfile: onNavigateToBusinessProfile,
                                onSelectProduct: { productId in }
                            )
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: maxHeight)
        .background(Color.backgroundSB)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: -4)
    }
}
