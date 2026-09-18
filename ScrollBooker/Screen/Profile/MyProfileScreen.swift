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
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    var onNavigateToUserSocial: (SocialNavigationParams) -> Void
    var onNavigateToMyCalendar: () -> Void
    var onNavigateToCamera: () -> Void
    let makeOpeningHoursViewModel: () -> OpeningHoursViewModel
    let onNavigateToPost: (ProfilePostSource, Int) -> Void

    @State private var activeSheet: ProfileSheet?
    @State private var openingHoursViewModel: OpeningHoursViewModel?
    // Set by a sheet's own action (e.g. tapping a link in ProfileMenuSheetView), then run
    // from .sheet's onDismiss — guarantees the sheet has fully closed before we navigate,
    // instead of the two animations racing each other.
    @State private var pendingSheetAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.profileController.viewState {
            case .idle, .loading:
                ProgressView()
                    .tint(.primarySB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .error:
                ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                    Task { await viewModel.loadProfile() }
                }

            case .success(let user):
                ProfileLayout(
                    user: user,
                    profileController: viewModel.profileController,
                    selectedTab: $viewModel.selectedTab,
                    onNavigateToUserSocial: onNavigateToUserSocial,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onShowOpeningHours: {
                        if openingHoursViewModel == nil {
                            openingHoursViewModel = makeOpeningHoursViewModel()
                        }
                        activeSheet = .openingHours
                    },
                    // Own profile is always isOwnProfile == true, so the employees tab's
                    // "Pick"/booking button never renders here — nothing to wire.
                    onNavigateToBooking: { _ in },
                    onNavigateToPost: onNavigateToPost,
                    onRefresh: {
                        await viewModel.refresh()
                    },
                    header: {
                        MyProfileHeaderView(
                            username: "@\(user.username)",
                            onOpenMenuSheet: { activeSheet = .menu },
                            onNavigateToCamera: onNavigateToCamera
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
        .task {
            await viewModel.loadProfile()
        }
        .sheet(item: $activeSheet, onDismiss: {
            pendingSheetAction?()
            pendingSheetAction = nil
        }) { sheet in
            switch sheet {
                case .menu:
                    ProfileMenuSheetView(
                        showMenuSheet: Binding(
                            get: { activeSheet == .menu },
                            set: { if !$0 { activeSheet = nil } }
                        ),
                        onCreatePost: { pendingSheetAction = onNavigateToCamera },
                        onNavigateToMyBusiness: { pendingSheetAction = onNavigateToMyBusiness },
                        onNavigateToSettings: { pendingSheetAction = onNavigateToSettings }
                    )
                case .openingHours:
                    if let userId = viewModel.profileController.profile?.id,
                       let openingHoursViewModel {
                        OpeningHoursSheetView(
                            viewModel: openingHoursViewModel,
                            userId: userId
                        )
                    }
                }
        }
    }
}
