//
//  ReviewSummaryCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

struct ReviewSummaryCardView: View {
    let summary: ReviewSummary
    @Binding var selectedRatings: Set<Int>
    
    private var maxCount: Int {
        summary.breakdown.map(\.count).max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            ForEach(summary.breakdown.sorted { $0.rating > $1.rating }, id: \.rating) { item in
                RatingRowView(
                    item: item,
                    maxCount: maxCount,
                    isSelected: selectedRatings.contains(item.rating),
                    onToggle: { toggle(item.rating) }
                )
            }
        }
        .padding(.horizontal, .base)
        .padding(.vertical, .s)
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Text(String(format: "%.1f", summary.averageRating))
                    .font(.system(size: 28, weight: .semibold))
                Text("(\(summary.totalReviews))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            StarRatingView(rating: summary.averageRating)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func toggle(_ rating: Int) {
        if selectedRatings.contains(rating) { selectedRatings.remove(rating) }
        else { selectedRatings.insert(rating) }
    }
}

#Preview("Light") {
    @Previewable @State var selected: Set<Int> = []
    
    ReviewSummaryCardView(
        summary: ReviewSummary(
            averageRating: 4.2,
            totalReviews: 100,
            breakdown: [
                RatingBreakdown(rating: 1, count: 10),
                RatingBreakdown(rating: 2, count: 10),
                RatingBreakdown(rating: 3, count: 10),
                RatingBreakdown(rating: 4, count: 10),
                RatingBreakdown(rating: 5, count: 60)
            ]
        ),
        selectedRatings: $selected
    )
}

#Preview("Dark") {
    @Previewable @State var selected: Set<Int> = []
    
    ReviewSummaryCardView(
        summary: ReviewSummary(
            averageRating: 4.2,
            totalReviews: 100,
            breakdown: [
                RatingBreakdown(rating: 1, count: 10),
                RatingBreakdown(rating: 2, count: 10),
                RatingBreakdown(rating: 3, count: 10),
                RatingBreakdown(rating: 4, count: 10),
                RatingBreakdown(rating: 5, count: 60)
            ]
        ),
        selectedRatings: $selected
    )
    .preferredColorScheme(.dark)
}
