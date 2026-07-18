//
//  NearbyBusinessItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct NearbyBusinessItemView: View {
    let business: NearbyBusiness
    let onNavigateToBusinessProfile: (String) -> Void
    private let itemWidth: CGFloat = 300
    
    var body: some View {
        let owner = business.owner
        let location = business.location
        let imageUrl = business.mediaFiles.first?.thumbnailUrl
        
        VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
            NearbyBusinessImageView(
                url: imageUrl ?? "placeholder.jpg",
                username: owner.username
            )
            
            HStack(alignment: .center, spacing: 0) {
                Text(owner.fullName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.ratingSB)
                    
                    Text(owner.counters.ratingsAverage.formatRating())
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text("(\(owner.counters.ratingsCount))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            
            Text(owner.profession)
                .font(.footnote)
                .foregroundColor(.gray)
                .lineLimit(1)
            
            Text(location.formattedAddress)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: itemWidth)
        .padding(.bottom, .s)
        .contentShape(Rectangle())
        .onTapGesture {
            onNavigateToBusinessProfile(owner.username)
        }
    }
}
