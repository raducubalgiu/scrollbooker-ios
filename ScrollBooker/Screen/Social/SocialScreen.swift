//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct SocialScreen: View {
    @State private var selectedTab: SocialTab = .reviews
    
    var body: some View {
        Header(title: "@radu_balgiu")
        
        VStack(spacing: 0) {
            SocialTabsView(selectedTab: $selectedTab)
            
            // CONȚINUT SWIPE-ABIL
            TabView(selection: $selectedTab) {
                ReviewsTabView()
                    .tag(SocialTab.reviews)
                FollowersTabView()
                    .tag(SocialTab.followers)
                FollowingsTabView()
                    .tag(SocialTab.following)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview("Light") {
    SocialScreen()
}

#Preview("Dark") {
    SocialScreen()
        .preferredColorScheme(.dark)
}
