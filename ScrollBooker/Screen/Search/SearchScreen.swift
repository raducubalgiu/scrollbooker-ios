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
    
    // NOU: lățimea reală a viewport-ului hărții, măsurată live prin GeometryReader.
    // Fără asta, formula de zoom presupunea o lățime fixă, greșită pe majoritatea device-urilor.
    @State private var mapViewportWidth: CGFloat = 0
    
    // NOU: task-ul curent de search, ca să putem anula unul vechi dacă vine unul nou
    // (evită race conditions unde un răspuns vechi suprascrie unul nou cu markeri greșiți).
    @State private var lastSearchTask: Task<Void, Never>? = nil

    private let minZoomDelta: Float = 0.5
    private let minMoveMeters: Double = 10000.0
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack(alignment: .top) {
            if isLoading {
                Color(.systemGray6).ignoresSafeArea(.all, edges: .top)
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
                
                Spacer()
                
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
                        businesses: viewModel.uiState.data,
                        onNavigateToBusinessProfile: { id in
                            // Trimitem ID-ul în sus către router
                            onNavigateToBusinessProfile(id)
                        },
                        onSelectProduct: { product in
                            // Gestiune selectare produs (dacă e cazul)
                            print("Produs selectat: \(product)")
                        }
                    )
                    .offset(y: max(0, currentOffset + dragOffset))
                    .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.85, blendDuration: 0), value: dragOffset)
                    .animation(.spring(response: 0.4, dampingFraction: 0.85), value: sheetPosition)
                    .gesture(
                        DragGesture(minimumDistance: 5)
                            .onChanged { value in
                                // Filtrare mișcare orizontală (păstrăm optimizarea anterioară pentru carusel)
                                let horizontalDistance = abs(value.translation.width)
                                let verticalDistance = abs(value.translation.height)
                                guard verticalDistance > horizontalDistance else { return }
                                
                                let proposedOffset = value.translation.height
                                
                                if sheetPosition == .expanded {
                                    if proposedOffset < 0 {
                                        // Rezistență când tragi în sus peste limita ecranului
                                        dragOffset = proposedOffset * 0.15
                                    } else {
                                        dragOffset = proposedOffset
                                    }
                                } else if sheetPosition == .collapsed {
                                    if proposedOffset > 0 {
                                        // FIXED: Rezistență cauciucată foarte rigidă când încerci să tragi sub Bottom Bar.
                                        // Dacă vrei să fie blocat TOTAL la pixel, înlocuiește linia de mai jos cu: dragOffset = 0
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
                                        // Snap bazat pe distanța parcursă
                                        if value.translation.height < -60 {
                                            sheetPosition = .expanded
                                        } else {
                                            sheetPosition = .collapsed
                                        }
                                    }
                                    dragOffset = 0 // Resetare obligatorie
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
        let selectedId = viewModel.selectedMarkerId
        
        let _ = print("🔍 DEBUG PINI: Total = \(markers.count) | Primary = \(markers.filter({ $0.isPrimary }).count) | Secondary = \(markers.filter({ !$0.isPrimary }).count)")
        
        // Filtrele tale matematice 1:1 din Android
        let bottomMarkers = markers.filter { !$0.isPrimary && $0.id != selectedId }
        let topMarkers = markers.filter { $0.isPrimary && $0.id != selectedId }
        let selectedMarker = markers.first { $0.id == selectedId }
        
        // NOU: GeometryReader în jurul hărții ca să măsurăm lățimea reală a viewport-ului.
        // E folosită direct în formula de zoom din handleCameraChange.
        GeometryReader { geo in
            Map(position: $cameraPosition) {
                // STRATUL 1 (Jos): Punctulețele simple
                ForEach(bottomMarkers) { m in
                    Annotation(m.owner.fullName, coordinate: m.clCoordinates, anchor: .center) {
                        SearchMarkerSecondary(color: m.businessShortDomain.domainColor)
                            // REZOLVARE BUG CACHE: Forțăm o identitate unică unind ID-ul cu starea "secondary"
                            .id("\(m.id)_secondary")
                            .drawingGroup() // Performanță Metal GPU
                            .onTapGesture {
                                viewModel.selectedMarkerId = m.id
                            }
                    }
                }
                
                // STRATUL 2 (Mijloc): Avatarele Premium neselectate
                ForEach(topMarkers) { m in
                    Annotation(m.owner.fullName, coordinate: m.clCoordinates, anchor: .bottom) {
                        SearchMarkerPrimary(
                            imageUrl: m.mediaFiles.first??.thumbnailUrl,
                            domainColor: m.businessShortDomain.domainColor
                        )
                        // REZOLVARE BUG CACHE: Forțăm o identitate unică unind ID-ul cu starea "primary"
                        .id("\(m.id)_primary")
                        .drawingGroup() // Performanță Metal GPU
                        .onTapGesture {
                            viewModel.selectedMarkerId = m.id
                        }
                    }
                }
                
                // STRATUL 3 (Sus): Pin-ul selectat curent
                if let m = selectedMarker {
                    Annotation(m.owner.fullName, coordinate: m.clCoordinates, anchor: .bottom) {
                        SearchMarkerPrimary(
                            imageUrl: m.mediaFiles.first??.thumbnailUrl,
                            domainColor: m.businessShortDomain.domainColor
                        )
                        .id("\(m.id)_selected") // Identitate unică dedicată selecției
                        .onTapGesture {
                            onNavigateToBusinessProfile(m.owner.username)
                        }
                        .scaleEffect(1.6, anchor: .bottom)
                        .shadow(color: Color.black.opacity(0.25), radius: 14, x: 0, y: 8)
                        .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .bottom)))
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: selectedId)
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

    // ÎN INTERIORUL STRUCTURII SEARCHSCREEN:
    private func handleCameraChange(context: MapCameraUpdateContext) {
        let region = context.region
        let spanLng = region.span.longitudeDelta
        let spanLat = region.span.latitudeDelta
        let center = region.center
        
        // 1. CALCUL BOUNDING BOX PURE (Matematică standard stabilă)
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
        
        // 2. CALCUL ZOOM CORECTAT: foloseste latimea REALA a viewport-ului (in puncte,
        // echivalent cu dp-urile din Android), nu o constanta presupusa.
        // Formula standard de tile-zoom Web Mercator: zoom = log2(width * 360 / (spanLng * 256))
        var currentZoom: Float = 10.0 // Valoare de fallback în caz de eroare
        
        if spanLng > 0, mapViewportWidth > 0 {
            let rawZoom = log2(Double(mapViewportWidth) * 360.0 / (spanLng * 256.0))
            
            if rawZoom.isFinite {
                currentZoom = max(1.0, min(20.0, Float(rawZoom)))
            }
        }
        
        // 3. DEBOUNCE: evităm request-uri redundante daca mișcarea/zoom-ul e neglijabil,
        // și anulăm orice search anterior încă în zbor ca să nu suprascrie un rezultat mai nou.
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
    
    // Expunem closure-urile primite din ecranul principal pentru navigare
    var onNavigateToBusinessProfile: (String) -> Void
    var onSelectProduct: (String) -> Void
    
    // O SINGURĂ proprietate de animație centralizată pentru tot panoul, evită epuizarea CPU-ului
    @State private var pulseSkeleton = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.primary.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 4) {
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
                        // FIXED: Înlocuit LoadingView() cu skeletons dinamice pulsatorii de performanță maximă
                        ForEach(1...3, id: \.self) { _ in
                            SearchCardSkeletonView(isAnimating: pulseSkeleton)
                        }
                        .onAppear {
                            // Pornim un singur ciclu de animație liniară pe opacitate pentru toate elementele simultan
                            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                                pulseSkeleton = true
                            }
                        }
                    } else {
                        ForEach(businesses, id: \.id) { business in
                            // Conectăm direct acțiunile native ale cardului tău
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
