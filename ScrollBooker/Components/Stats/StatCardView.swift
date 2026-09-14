//
//  StatCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct StatCardView: View {
    let label: String
    let value: String
    var containerColor: Color = .surfaceSB
    var contentColor: Color = .onSurfaceSB
    var borderColor: Color? = nil
    var gradientColors: [Color]? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline.bold())
                .foregroundColor(contentColor)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(value)
                .font(.title3.bold())
                .foregroundColor(contentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.base)
        .background(
            Group {
                if let gradientColors {
                    LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                } else {
                    containerColor
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            if let borderColor {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 0.55)
            }
        }
    }
}
