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

struct SearchScreen: View {
    @State private var sheetPosition: SheetPosition = .collapsed
    @State private var dragOffset: CGFloat = 0
    @State private var isLoading: Bool = true
    
    private let headerHeight: CGFloat = 56
    private let headerBottomPadding: CGFloat = 12
    private let collapsedHeight: CGFloat = 160
    
    var body: some View {
        ZStack(alignment: .top) {
            if isLoading {
                Color(.systemGray6)
                    .ignoresSafeArea(.all, edges: .top)
                    .overlay(
                        Text("Se încarcă harta...")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    )
            } else {
                Map()
                    .ignoresSafeArea(.all, edges: .top)
            }
            
            VStack(spacing: headerBottomPadding) {
                ScreenHeaderView()
                    .padding(.horizontal, .base)
                
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
                    
                    AirbnbBottomSheet(maxHeight: sheetMaxHeight, isLoading: isLoading)
                        .offset(y: max(0, currentOffset + dragOffset))
                        .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.85, blendDuration: 0), value: dragOffset)
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: sheetPosition)
                        .gesture(
                            DragGesture(minimumDistance: 5)
                                .onChanged { value in
                                    let proposedOffset = value.translation.height
                                    if sheetPosition == .expanded && proposedOffset < 0 {
                                        dragOffset = proposedOffset * 0.15
                                    } else {
                                        dragOffset = proposedOffset
                                    }
                                }
                                .onEnded { value in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isLoading = false
                }
            }
        }
//        .onAppear {
//            // 1. Pornești încărcarea datelor din rețea prin ViewModel-ul tău
//            Task {
//                // Presupunem că ai o funcție asincronă care aduce datele din baza de date/API
//                await viewModel.fetchLocations()
//                
//                // 2. Imediat ce serverul a răspuns (fie că durează 50ms sau 300ms), oprești skeletonul fluid
//                withAnimation(.easeInOut(duration: 0.25)) {
//                    isLoading = false
//                }
//            }
//        }
    }
}

struct ScreenHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading, 16)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Tuns + Stilizat Barbă")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("Azi, 16:30 · 1 persoană")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.primary.opacity(0.12), lineWidth: 1))
            }
            .padding(.trailing, 8)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct AirbnbBottomSheet: View {
    let maxHeight: CGFloat
    let isLoading: Bool
    
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
                    Text("Peste 50 de rezultate găsite")
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
                        // Will display Skeletons here
                    } else {
                        ForEach(1...50, id: \.self) { index in
                            HStack(spacing: 16) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.primary.opacity(0.06))
                                    .frame(width: 90, height: 90)
                                    
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Locație Premium \(index)")
                                        .font(.headline)
                                    Text("★ 4.95 · Centru")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("250 RON / noapte")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
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
