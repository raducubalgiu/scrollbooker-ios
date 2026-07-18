//
//  BusinessSummaryActions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct BusinessSummaryActions: View {
    let counters: BusinessProfileCounters
    let isFollow: Bool?
    let isFollowEnabled: Bool
    let onFollow: () -> Void
    let onFlyToReviewsSection: () -> Void
    let onNavigateToBooking: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                CounterItemView(
                    counter: counters.ratingsCount,
                    label: String(localized: "reviews"),
                    onNavigate: onFlyToReviewsSection
                )
                
                VerticalDivider(height: 15).padding(.horizontal, 2)
                
                CounterItemView(
                    counter: counters.followersCount,
                    label: String(localized: "followers"),
                    onNavigate: {}
                )
                
                VerticalDivider(height: 15).padding(.horizontal, 2)
                
                CounterItemView(
                    counter: counters.followingsCount,
                    label: String(localized: "following"),
                    onNavigate: {}
                )
            }
            .frame(maxWidth: .infinity)
            
            HStack(alignment: .center, spacing: AppSize.m.rawValue) {
                MainButton(
                    title: String(localized: "book"),
                    size: .medium,
                    onClick: onNavigateToBooking
                )
                .frame(maxWidth: .infinity)

                if let isFollow = isFollow {
                    let buttonTitle = isFollow ? String(localized: "following") : String(localized: "follow")
                    
                    MainButtonOutlined(
                        title: buttonTitle,
                        size: .medium,
                        fullWidth: true,
                        onClick: {}
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .base)
        }
        .frame(maxWidth: .infinity)
    }
}
