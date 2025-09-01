//
//  RatingRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

struct RatingRowView: View {
    let item: RatingBreakdown
    let maxCount: Int
    let isSelected: Bool
    let onToggle: () -> Void
    
    private var progress: CGFloat {
        guard maxCount > 0 else  { return 0 }
        let ratio = CGFloat(item.count) / CGFloat(maxCount)
        return max(0, min(1, ratio))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            CheckboxView(checked: isSelected, onChange: onToggle)
            
            Text("\(item.rating)")
                .font(.subheadline)
                .frame(width: 14, alignment: .leading)

            Bar(progress: progress, hasValue: item.count > 0)
                .frame(height: 6)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
            
            Text("\(item.count)")
                .font(.subheadline.bold().monospacedDigit())
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 28, alignment: .trailing)
        }
        .frame(height: 28)
    }
    
    private struct Bar: View {
        let progress: CGFloat
        let hasValue: Bool
        var body: some View {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.25))
                    Capsule()
                        .fill(hasValue ? Color.primarySB : Color.gray.opacity(0.35))
                        .frame(width: geo.size.width * progress)
                        .animation(.easeInOut(duration: 0.25), value: progress)
                }
                .clipped()
            }
        }
    }
}

#Preview("Light") {
    RatingRowView(
        item: RatingBreakdown(rating: 5, count: 40),
        maxCount: 100,
        isSelected: true,
        onToggle: {}
    )
    .padding(.horizontal)
}

#Preview("Dark") {
    RatingRowView(
        item: RatingBreakdown(rating: 5, count: 40),
        maxCount: 100,
        isSelected: true,
        onToggle: {}
    )
    .preferredColorScheme(.dark)
}
