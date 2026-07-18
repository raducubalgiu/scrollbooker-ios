//
//  BusinessSummarySection.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct BusinessSummarySection: View {
    let owner: BusinessProfileOwner
    let distance: Float?
    let address: String
    let formattedAddress: String
    let openingHours: OpeningHours
    let isFollow: Bool?
    let isFollowEnabled: Bool
    let onFollow: () -> Void
    let onNavigateToOwnerProfile: (String) -> Void
    let onFlyToReviewsSection: () -> Void
    let onNavigateToBooking: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                AvatarWithRatingView(
                    url: owner.avatarURL,
                    rating: Double(owner.counters.ratingsAverage),
                    size: .xl,
                    onClick: { onNavigateToOwnerProfile(owner.username) },
                )
                
                Spacer().frame(width: 16)
                
                BusinessSummaryActions(
                    counters: owner.counters,
                    isFollow: isFollow,
                    isFollowEnabled: isFollowEnabled,
                    onFollow: onFollow,
                    onFlyToReviewsSection: onFlyToReviewsSection,
                    onNavigateToBooking: onNavigateToBooking
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .base)
            
            BusinessSummaryDetails(
                distance: distance,
                fullName: owner.fullName,
                address: formattedAddress,
                openingHours: openingHours
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, .base)
    }
}
