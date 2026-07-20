//
//  UserProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import SwiftUI

struct UserProfileScreen: View {
    @Bindable var viewModel: UserProfileViewModel
        
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    var onNavigateToUserSocial: (SocialNavigationParams) -> Void
    var onNavigateToBooking: (BookingNavigationParams) -> Void
    var onBack: () -> Void

    @State private var activeSheet: ProfileSheet?
    
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
                        onNavigateToUserSocial: onNavigateToUserSocial,
                        onNavigateToUserProfile: onNavigateToUserProfile,
                        onShowOpeningHours: {
                            activeSheet = .openingHours
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
                            UserProfileActions(
                                isBusinessOrEmployee: user.isBusinessOrEmployee,
                                isFollow: user.isFollow,
                                isFollowEnabled: true,
                                onFollow: {},
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
                                },
                            )
                        }
                    )
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

