//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct ProfileScreen: View {
    let viewModel: ProfileViewModel
    
    @State private var showMenuSheet = false
    
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserProfile: () -> Void
    var onNavigateToUserSocial: () -> Void
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.uiState.data == nil {
                ProgressView()
            } else if let user = viewModel.uiState.data {
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
                    }
                )
                .sheet(isPresented: $showMenuSheet) {
                    ProfileMenuSheetView(
                        showMenuSheet: $showMenuSheet,
                        onCreatePost: {},
                        onNavigateToMyBusiness: onNavigateToMyBusiness,
                        onNavigateToSettings: onNavigateToSettings
                    )
                }
            } else {
                ContentUnavailableView(
                    String(localized: "profileUnavailable"),
                    systemImage: "person.crop.circle.badge.exclamationmark"
                )
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadProfile()
        }
    }
}
