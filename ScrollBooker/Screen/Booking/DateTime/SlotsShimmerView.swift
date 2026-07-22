//
//  SlotsShimmerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct SlotsShimmerView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { _ in
                    
                    HStack {
                        SkeletonBar(
                            width: 60,
                            height: 16,
                            cornerRadius: 6
                        )
                        
                        Spacer()
                    }
                    .padding(.all, 18)
                    .frame(height: 56)
                    .background(Color.surfaceSB)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.dividerSB, lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                }
            }
            .padding(.top, 8)
        }
        .disabled(true)
    }
}
