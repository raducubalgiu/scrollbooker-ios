//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MyProfileScreen: View {
    @Bindable var viewModel: MyProfileViewModel
        
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserProfile: (Int, String) -> Void
    var onNavigateToUserSocial: () -> Void
    var onNavigateToMyCalendar: () -> Void

    @State private var activeSheet: ProfileSheet?
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.profileController.viewState {
            case .idle, .loading:
                ProgressView()
                    .tint(.primarySB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .error:
                ErrorView(message: String(localized: "errorOccurred")) {
                    Task { await viewModel.loadProfile() }
                }
                
            case .success:
                if let user = viewModel.profileController.uiState.data {
                    ProfileLayout(
                        user: user,
                        onNavigateToUserSocial: onNavigateToUserSocial,
                        onNavigateToUserProfile: onNavigateToUserProfile,
                        onShowOpeningHours: { activeSheet = .openingHours },
                        header: {
                            MyProfileHeaderView(
                                username: "@\(user.username)",
                                onOpenMenuSheet: { activeSheet = .menu }
                            )
                            .padding(.vertical).padding(.horizontal)
                        },
                        actions: {
                            MyProfileActionsView(
                                isBusinessOrEmployee: user.isBusinessOrEmployee,
                                onNavigateToEditProfile: onNavigateToEditProfile,
                                onNavigateToMyCalendar: onNavigateToMyCalendar,
                                onShareProfile: {}
                            )
                        }
                    )
                }
            }
        }
        .task {
            await viewModel.loadProfile()
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .menu:
                ProfileMenuSheetView(
                    showMenuSheet: Binding(
                        get: { activeSheet == .menu },
                        set: { if !$0 { activeSheet = nil } }
                    ),
                    onCreatePost: {},
                    onNavigateToMyBusiness: onNavigateToMyBusiness,
                    onNavigateToSettings: onNavigateToSettings
                )
            case .openingHours:
                OpeningHoursSheetView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}
