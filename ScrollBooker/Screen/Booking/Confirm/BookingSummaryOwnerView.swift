//
//  BookingSummaryOwnerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct BookingSummaryOwnerView: View {
    let owner: BookingFlowUser
    
    private var formattedRating: String {
        String(format: "%.1f", owner.ratingsAverage)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            AvatarView(
                imageURL: owner.avatarURL,
                size: .l
            )
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(owner.fullName)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
                
                HStack(spacing: 4) {
                    Text(formattedRating)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.onBackgroundSB)
                    
                    StarRatingView(
                        rating: owner.ratingsAverage,
                        imageScale: .small
                    )
                    
                    Text("(\(owner.ratingsCount))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(.all, .base)
    }
}
