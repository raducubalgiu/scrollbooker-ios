//
//  SearchMapLoading.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import SwiftUI

struct SearchMapLoading: View {
    var dotSize: CGFloat = 9
    var spaceBetween: CGFloat = 6
    var animationDelay: Double = 0.14
    
    @State private var animateDot1 = false
    @State private var animateDot2 = false
    @State private var animateDot3 = false
    
    var body: some View {
        HStack(spacing: spaceBetween) {
            Circle()
                .fill(animateDot1 ? Color.onBackgroundSB : Color.backgroundSB)
                .frame(width: dotSize, height: dotSize)
            
            Circle()
                .fill(animateDot2 ? Color.onBackgroundSB : Color.backgroundSB)
                .frame(width: dotSize, height: dotSize)
            
            Circle()
                .fill(animateDot3 ? Color.onBackgroundSB : Color.backgroundSB)
                .frame(width: dotSize, height: dotSize)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Color.backgroundSB)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                animateDot1 = true
            }
            
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true).delay(animationDelay)) {
                animateDot2 = true
            }
            
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true).delay(animationDelay * 2)) {
                animateDot3 = true
            }
        }
    }
}
