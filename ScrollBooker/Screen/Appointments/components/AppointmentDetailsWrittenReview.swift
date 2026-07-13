//
//  AppointmentDetailsWrittenReview.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

struct AppointmentDetailsWrittenReview: View {
    let customerAvatar: String
    let isCustomer: Bool
    let review: String?
    let rating: Int
    var onOpenCancelSheet: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    AvatarView(
                        imageURL: URL(string: customerAvatar),
                        size: .s
                    )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("A evaluat \(rating) din 5")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        StarRatingView(
                            rating: Double(rating),
                            imageScale: .small
                        )
                    }
                }
                
                Spacer()
                
                if isCustomer {
                    Button(action: onOpenCancelSheet) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.primary)
                            .padding(4)
                    }
                }
            }
            
            if let reviewText = review, !reviewText.isEmpty {
                Text(reviewText)
                    .font(.subheadline)
                    .italic()
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.surfaceSB)
        .cornerRadius(12)
    }
}
