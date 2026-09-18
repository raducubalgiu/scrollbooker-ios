//
//  UserProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import SwiftUI

struct UserProfileScreen: View {
    @Bindable var viewModel: UserProfileViewModel

    var onBack: () -> Void
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToMyCalendar: () -> Void
    let onNavigateToPost: (ProfilePostSource, Int) -> Void
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    var onNavigateToUserSocial: (SocialNavigationParams) -> Void
    var onNavigateToBooking: (BookingNavigationParams) -> Void

    @State private var activeSheet: ProfileSheet?
    @State private var pendingSheetAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.profileController.viewState {
            case .idle, .loading:
                ProgressView()
                    .tint(.primarySB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .error(let message):
                ErrorView(message: message) {
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
                        activeSheet = .openingHours
                    },
                    onNavigateToBooking: onNavigateToBooking,
                    onNavigateToPost: onNavigateToPost,
                    onRefresh: {
                        await viewModel.refresh()
                    },
                    header: {
                        UserProfileHeaderView(
                            username: "@\(user.username)",
                            onBack: onBack
                        )
                        .padding(.vertical)
                        .padding(.horizontal)
                    },
                    actions: {
                        if user.isOwnProfile {
                            MyProfileActionsView(
                                isBusinessOrEmployee: user.isBusinessOrEmployee,
                                onNavigateToEditProfile: onNavigateToEditProfile,
                                onNavigateToMyCalendar: onNavigateToMyCalendar,
                                onShareProfile: {}
                            )
                        } else {
                            UserProfileActions(
                                isBusinessOrEmployee: user.isBusinessOrEmployee,
                                isFollow: user.isFollow,
                                isFollowEnabled: true,
                                onFollow: {
                                    Task { await viewModel.toggleFollow() }
                                },
                                onNavigateToBooking: {
                                    guard let businessId = user.businessId,
                                          let businessOwnerId = user.businessOwner?.id else {
                                        print("⚠️ Navigarea la Booking a fost anulată: businessId sau businessOwnerId este NULL.")
                                        return
                                    }

                                    onNavigateToBooking(
                                        BookingNavigationParams(
                                            businessId: businessId,
                                            userId: user.id,
                                            businessOwnerId: businessOwnerId,
                                            source: .profile,
                                            selectedProductId: nil
                                        )
                                    )
                                }
                            )
                        }
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
                    onCreatePost: {},
                    onNavigateToMyBusiness: { pendingSheetAction = onNavigateToMyBusiness },
                    onNavigateToSettings: { pendingSheetAction = onNavigateToSettings }
                )
            case .openingHours:
                OpeningHoursSheetView(
                    profileController: viewModel.profileController,
                    userId: viewModel.userId
                )
            }
        }
    }
}
