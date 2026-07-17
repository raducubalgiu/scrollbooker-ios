//
//  SearchMarkerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import SwiftUI

struct SearchMarker: View {
    let isPrimary: Bool
    let isSelected: Bool
    let marker: BusinessMarker
    var baseAvatarSize: CGFloat = 50
    let onClick: () -> Void
    
    var body: some View {
        let showPrimaryUi = isPrimary || isSelected
        
        Button(action: onClick) {
            ZStack(alignment: .bottom) {
                SearchMarkerSecondary(color: marker.businessShortDomain.domainColor)
                
                if showPrimaryUi {
                    SearchMarkerPrimary(
                        imageUrl: marker.mediaFiles.first??.thumbnailUrl,
                        domainColor: marker.businessShortDomain.domainColor,
                        baseAvatarSize: baseAvatarSize
                    )
                    .scaleEffect(isSelected ? 1.6 : 1.0, anchor: .bottom)
                    .shadow(color: Color.black.opacity(isSelected ? 0.25 : 0.12), radius: isSelected ? 14 : 6, x: 0, y: isSelected ? 8 : 3)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.9, anchor: .bottom)),
                            removal: .opacity.combined(with: .scale(scale: 0.9, anchor: .bottom))
                        )
                    )
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isSelected)
    }
}
