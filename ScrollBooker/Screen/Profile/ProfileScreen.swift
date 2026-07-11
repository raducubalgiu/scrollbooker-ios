//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct ProfileScreen: View {
    let viewModel: ProfileViewModel
        
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserProfile: () -> Void
    var onNavigateToUserSocial: () -> Void

    @State private var showMenuSheet = false

    init(
        viewModel: ProfileViewModel,
        onNavigateToEditProfile: @escaping () -> Void = { },
        onNavigateToSettings: @escaping () -> Void = { },
        onNavigateToMyBusiness: @escaping () -> Void = { },
        onNavigateToUserProfile: @escaping () -> Void = { },
        onNavigateToUserSocial: @escaping () -> Void = { }
    ) {
        self.viewModel = viewModel
        self.onNavigateToEditProfile = onNavigateToEditProfile
        self.onNavigateToSettings = onNavigateToSettings
        self.onNavigateToMyBusiness = onNavigateToMyBusiness
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToUserSocial = onNavigateToUserSocial
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.uiState.data == nil {
                ProgressView()
                    .tint(.primarySB)
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
            } else if let errorMessage = viewModel.errorMessage {
                // DACĂ DECODRE-A EȘUEAZĂ, VEZI IMEDIAT CÂMPUL GREȘIT PE ECRAN!
                ContentUnavailableView {
                    Label("Eroare Decodare Date", systemImage: "exclamationmark.triangle")
                        .foregroundColor(.errorSB)
                } description: {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } actions: {
                    Button("Reîncearcă") {
                        Task { await viewModel.refresh() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                // Această ramură va fi acum doar starea inițială curată, înainte de load
                ContentUnavailableView(
                    String(localized: "profileUnavailable"),
                    systemImage: "person.crop.circle.badge.exclamationmark"
                )
            }
        }
        .task {
            await viewModel.loadProfile()
        }
    }
}
