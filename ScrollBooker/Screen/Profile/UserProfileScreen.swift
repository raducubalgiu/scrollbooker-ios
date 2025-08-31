//
//  UserProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct UserProfileScreen: View {
    @State private var measuredHeight: CGFloat = 0
    
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserSocial: () -> Void
    
    var user = dummyUserProfile
    
    var body: some View {
        ProfileLayout(
            user: user,
            header: {
                ProfileHeaderView(username: "@\(user.username)")
                .padding(.vertical)
                .padding(.horizontal)
            },
            actions: {
                UserProfileActions()
            }
        )
    }
}

#Preview("Light") {
    UserProfileScreen(
        onNavigateToEditProfile: {},
        onNavigateToSettings: {},
        onNavigateToMyBusiness: {},
        onNavigateToUserSocial: {}
    )
}

#Preview("Dark") {
    UserProfileScreen(
        onNavigateToEditProfile: {},
        onNavigateToSettings: {},
        onNavigateToMyBusiness: {},
        onNavigateToUserSocial: {}
    )
        .preferredColorScheme(.dark)
}

