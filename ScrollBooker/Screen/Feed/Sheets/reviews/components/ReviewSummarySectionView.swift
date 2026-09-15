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
                Text(String(summary.ratingsAverage.formatRating()))
                    .font(.system(size: 32, weight: .bold))
                
                StarRatingView(rating: Double(summary.ratingsAverage))
                
                Text("\(summary.ratingsCount) recenzii")
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
