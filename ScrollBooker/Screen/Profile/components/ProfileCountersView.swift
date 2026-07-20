//
//  ProfileCountersView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileCountersView: View {
    var counters: UserCounters
    var onNavigateToUserSocial: (SocialTab) -> Void
    
    var body: some View {
        HStack {
            ProfileCounterView(
                counter: counters.ratingsCount,
                label: String(localized: "reviews"),
                onClick: { onNavigateToUserSocial(SocialTab.reviews) }
            )
            
            VerticalDivider(height: 25)
                .padding(.horizontal, .m)
            
            ProfileCounterView(
                counter: counters.followersCount,
                label: String(localized: "followers"),
                onClick: { onNavigateToUserSocial(SocialTab.followers) }
            )
            
            VerticalDivider(height: 25)
                .padding(.horizontal, .m)
            
            ProfileCounterView(
                counter: counters.followingsCount,
                label: String(localized: "following"),
                onClick: { onNavigateToUserSocial(SocialTab.following) }
            )
        }
    }
}
