//
//  LinkedProductsBusinessHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct LinkedProductsBusinessHeaderView: View {
    let business: LinkedProductsBusinessSummary

    private var formattedRating: String {
        business.ratingsAverage.formatRating()
    }

    private var locationSummary: String? {
        var parts: [String] = []

        if let distanceKm = business.distanceKm {
            parts.append("\(String(format: "%.1f", distanceKm))km")
        }

        if let address = business.address {
            parts.append(address)
        }

        return parts.isEmpty ? nil : parts.joined(separator: " - ")
    }

    var body: some View {
        HStack(spacing: 16) {
            AvatarView(
                imageURL: business.avatarURL,
                size: .l
            )
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(business.fullName)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)

                HStack(spacing: 4) {
                    Text(formattedRating)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.onBackgroundSB)

                    StarRatingView(
                        rating: Double(business.ratingsAverage),
                        imageScale: .small
                    )

                    Text("(\(business.ratingsCount))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if let locationSummary {
                    Text(locationSummary)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(.all, .base)
    }
}
