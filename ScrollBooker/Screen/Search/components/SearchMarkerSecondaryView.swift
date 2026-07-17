//
//  SearchMarkerSecondaryView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import SwiftUI

struct SearchMarkerSecondary: View {
    var markerSize: CGFloat = 16
    var borderWidth: CGFloat = 3
    let color: Color
    var backgroundColor: Color = Color.backgroundSB
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color.opacity(0.08), color.opacity(0.6), color],
                        center: .center,
                        startRadius: 0,
                        endRadius: markerSize / 2
                    )
                )
            
            Circle()
                .stroke(backgroundColor, lineWidth: borderWidth)
                .padding(borderWidth / 2)
            
            Circle()
                .fill(color)
                .frame(width: markerSize / 2.2, height: markerSize / 2.2)
        }
        .frame(width: markerSize, height: markerSize)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}
