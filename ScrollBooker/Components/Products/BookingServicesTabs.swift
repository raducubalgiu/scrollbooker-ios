//
//  BookingServicesTabs.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct BookingServicesTabs: View {
    let activeSectionId: Int
    let serviceGroups: [BusinessServicesWithProducts]
    let onTabSelect: (Int) -> Void
    
    // Spațiu de nume pentru animația de alunecare
    @Namespace private var tabAnimation
    
    var body: some View {
        ScrollViewReader { tabProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(serviceGroups, id: \.service.id) { group in
                        // Extragem fiecare tab individual într-o sub-componentă dedicată
                        ServiceTabItemView(
                            group: group,
                            isSelected: group.service.id == activeSectionId,
                            animationNamespace: tabAnimation,
                            onTap: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    onTabSelect(group.service.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .onChange(of: activeSectionId) { _, newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    tabProxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .background(Color.backgroundSB)
    }
}

// MARK: - Sub-componentă: ServiceTabItemView
struct ServiceTabItemView: View {
    let group: BusinessServicesWithProducts
    let isSelected: Bool
    let animationNamespace: Namespace.ID
    let onTap: () -> Void
    
    var body: some View {
        Text(group.service.name) // Schimbă cu shortName dacă îl ai disponibil
            .font(.system(size: 16, weight: isSelected ? .bold : .medium))
            .foregroundColor(isSelected ? .onSurfaceSB : .onBackgroundSB) // Înlocuiește cu culorile tale (.onSurfaceBGSB / .onBackgroundSB)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(height: 42)
            .background(
                tabBackgroundView
            )
            .contentShape(Rectangle())
            .id(group.service.id)
            .onTapGesture(perform: onTap)
    }
    
    // MARK: - Fundalul animat izolat
    @ViewBuilder
    private var tabBackgroundView: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.surfaceSB) // Înlocuiește cu culoarea ta (.surfaceBGSB)
                .matchedGeometryEffect(id: "activeTabBackground", in: animationNamespace)
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
        }
    }
}
