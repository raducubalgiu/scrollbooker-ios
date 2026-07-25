//
//  WrittenReviewCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct ReviewActionUiState: Equatable {
    let likeCount: Int
    let isLiked: Bool
    let isLikedByProductOwner: Bool
}

struct WrittenReviewCard: View {
    let review: Review
    let reviewUi: ReviewActionUiState
    var onNavigateToReviewDetail: () -> Void
    var onLike: () -> Void
    
    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: review.createdAt) else { return review.createdAt }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy • HH:mm"
        return outputFormatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                AvatarView(
                    imageURL: review.customer.avatarURL,
                    size: .m
                )
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(review.customer.fullName)
                            .font(.body)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Text(formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    StarRatingView(
                        rating: Double(review.rating),
                        imageScale: .small
                    )
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onNavigateToReviewDetail()
            }
            
            Group {
                if !review.review.isEmpty {
                    Text(review.review)
                        .font(.body)
                } else {
                    Text("...")
                        .font(.body)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center) {
                Spacer()
                
                Group {
                    if reviewUi.isLikedByProductOwner {
                        AvatarView(
                            imageURL: review.productBusinessOwner.avatarURL,
                            size: .xs
                        )
                    }
                }
                .frame(height: 24)
                
                HStack(spacing: 4) {
                    if reviewUi.likeCount > 0 {
                        Text("\(reviewUi.likeCount)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(reviewUi.isLiked ? .errorSBB : .gray)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Image(systemName: reviewUi.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(reviewUi.isLiked ? .red : .gray)
                }
                .animation(.smooth(duration: 0.2), value: reviewUi.likeCount)
                .contentShape(Rectangle())
                .onTapGesture {
                    onLike()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}
