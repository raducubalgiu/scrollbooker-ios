//
//  BusinessReviewItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct BusinessReviewCard: View {
    let review: BusinessProfileReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                HStack(spacing: 12) {
                    AvatarView(size: .m)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(review.reviewer.fullName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.onBackgroundSB)
                            .lineLimit(1)
                        
                        Text("@\(review.reviewer.username)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                StarRatingView(
                    rating: Double(review.rating),
                    imageScale: .small
                )
            }
            
            Text(review.review)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

