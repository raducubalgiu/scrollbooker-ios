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
    let isEditable: Bool
    let createdAt: String
    var onOpenOptions: () -> Void

    private var formattedCreatedAt: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: createdAt) else { return createdAt }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy • HH:mm"
        return outputFormatter.string(from: date)
    }

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
                
                if isCustomer && isEditable {
                    Button(action: onOpenOptions) {
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

            Text(formattedCreatedAt)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.surfaceSB)
        .cornerRadius(12)
    }
}
