//
//  SkeletonBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SkeletonBar: View {
    var width: CGFloat
    var height: CGFloat = 12
    var cornerRadius: CGFloat = 6

    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.primary.opacity(isAnimating ? 0.16 : 0.07))
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}
