//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MyProfileScreen: View {
    @EnvironmentObject private var session: SessionManager
    @State private var measuredHeight: CGFloat = 0
    
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserSocial: () -> Void
    var onNavigateToUserProfile: () -> Void
    
    var user = dummyUserProfile
    
    var body: some View {
        ProfileLayout(
            user: user,
            onNavigateToUserSocial: onNavigateToUserSocial,
            header: {
                MyProfileHeaderView(username: "@\(user.username)")
                .padding(.vertical)
                .padding(.horizontal)
            },
            actions: {
                MyProfileActionsView(
                    onNavigateToEditProfile: onNavigateToEditProfile
                )
            },
            onNavigateToUserProfile: onNavigateToUserProfile
        )
        
        Button {
            session.logout()
        } label: {
            Text("Logout")
        }
    }
}

#Preview("Light") {
    MyProfileScreen(
        onNavigateToEditProfile: {},
        onNavigateToSettings: {},
        onNavigateToMyBusiness: {},
        onNavigateToUserSocial: {},
        onNavigateToUserProfile: {}
    )
}

#Preview("Dark") {
    MyProfileScreen(
        onNavigateToEditProfile: {},
        onNavigateToSettings: {},
        onNavigateToMyBusiness: {},
        onNavigateToUserSocial: {},
        onNavigateToUserProfile: {}
    )
        .preferredColorScheme(.dark)
}
