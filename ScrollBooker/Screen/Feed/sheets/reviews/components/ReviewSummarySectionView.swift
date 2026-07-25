//
//  ReviewSummarySectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct ReviewsSummarySectionView: View {
    let summary: ReviewSummary
    let selectedRatings: Set<Int>
    var onRatingClick: (Int) -> Void
    
    private var maxCount: Int {
        summary.breakdown.map { $0.count }.max() ?? 1
    }
    
    private var isEnabled: Bool {
        summary.ratingsCount > 0
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            VStack(spacing: 6) {
                Text(String(format: "%.1f", summary.ratingsAverage))
                    .font(.system(size: 32, weight: .bold))
                
                StarRatingView(rating: Double(summary.ratingsAverage))
                
                Text("100 recenzii")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(minWidth: 80)
            
            VStack(spacing: 8) {
                ForEach(summary.breakdown.sorted(by: { $0.rating > $1.rating }), id: \.rating) { item in
                    let progress = maxCount > 0 ? CGFloat(item.count) / CGFloat(maxCount) : 0.0
                    
                    ReviewSummaryCheckbox(
                        rating: item.rating,
                        progress: progress,
                        count: item.count,
                        isEnabled: isEnabled,
                        isChecked: selectedRatings.contains(item.rating),
                        onTap: {
                            onRatingClick(item.rating)
                        }
                    )
                }
            }
        }
        .padding(.leading, 16)
        .padding(.top, 16)
        .padding(.trailing, 8)
        .background(Color.backgroundSB)
        .cornerRadius(8)
    }
}

struct ReviewSummaryCheckbox: View {
    let rating: Int
    let progress: CGFloat
    let count: Int
    let isEnabled: BooleanLiteralType
    let isChecked: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 18, height: 18)
            .background(
                Group {
                    if !isEnabled {
                        Color.dividerSB
                    } else if isChecked {
                        Color.primarySB
                    } else {
                        Color.clear
                    }
                }
            )
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        !isEnabled ? Color.dividerSB : (isChecked ? Color.accentColor : Color.dividerSB),
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if isEnabled { onTap() }
            }
            
            Text("\(rating)")
                .font(.body)
                .bold()
                .frame(width: 16, alignment: .trailing)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 5)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.primarySB)
                        .frame(width: geometry.size.width * progress, height: 5)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 5)
            
            Text("\(count)")
                .font(.body)
                .bold()
                .frame(width: 35, alignment: .trailing)
        }
    }
}
