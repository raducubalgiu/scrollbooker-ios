//
//  BusinessReviewTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessReviewsTabView: View {
    let ratingsCount: Int
    let ratingsAverage: Float
    let reviews: BusinessProfileReviews
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                StarRatingView(rating: Double(ratingsAverage))
                
                HStack(spacing: AppSize.s.rawValue) {
                    Text(ratingsAverage.formatRating())
                        .font(.headline.bold())
                    Text("(\(ratingsCount) recenzii)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, .xl)
            
            ForEach(reviews.data) { review in
                BusinessReviewCard(review: review)
                    .padding(.bottom, .xl)
            }
        }
        .padding(.horizontal, .base)
    }
}
