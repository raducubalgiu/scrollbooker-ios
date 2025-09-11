//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MyProfileScreen: View {
    @EnvironmentObject private var session: SessionManager
    @State private var showMenuSheet = false
    
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
            onNavigateToUserProfile: onNavigateToUserProfile,
            header: {
                MyProfileHeaderView(
                    username: "@\(user.username)",
                    onOpenMenuSheet: { showMenuSheet = true }
                )
                .padding(.vertical)
                .padding(.horizontal)
            },
            actions: {
                MyProfileActionsView(
                    onNavigateToEditProfile: onNavigateToEditProfile
                )
                
                Button {
                    session.logout()
                } label: {
                    Text("Logout")
                }
            },
        )
        .sheet(isPresented: $showMenuSheet) {
            ProfileMenuSheetView(
                showMenuSheet: $showMenuSheet,
                onCreatePost: {},
                onNavigateToMyBusiness: onNavigateToMyBusiness,
                onNavigateToSettings: onNavigateToSettings
            )
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
