//
//  ReviewItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import SwiftUI

struct ReviewCardView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AvatarView(imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg")!)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.customer.fullName)
                        .font(.subheadline.weight(.semibold))
                    
                    Text("2024-05-23 18:30")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(ReviewLabel.from(value: review.rating).text)
                .font(.headline)
            
            StartRatingView(rating: review.rating)
            
            Text(review.review)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    Text("addComment")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    Image(systemName: review.isLiked ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(review.isLiked ? .errorSB : .gray)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview("Light") {
    ReviewCardView(
        review: userReviews[0]
    )
}

#Preview("Dark") {
    ReviewCardView(
        review: userReviews[0]
    )
    .preferredColorScheme(.dark)
}
