//
//  ProfileLayout.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileLayout<Header: View, Actions: View>: View {
    let user: UserProfile
    let onNavigateToUserSocial: (SocialNavigationParams) -> Void
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onShowOpeningHours: () -> Void

    @ViewBuilder var header: () -> Header
    @ViewBuilder var actions: () -> Actions

    @State private var selectedTab: ProfileTab = .posts
    @Namespace private var indicatorNS

    private var isEmployee: Bool {
        user.isBusinessOrEmployee && user.id != user.businessOwner?.id
    }

    private var availableTabs: [ProfileTab] {
        ProfileTab.getTabs(
            isBusinessOrEmployee: user.isBusinessOrEmployee,
            isEmployee: isEmployee,
            isOwnProfile: user.isOwnProfile
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            header()

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    VStack(spacing: 15) {
                        ProfileCountersView(
                            counters: user.counters,
                            onNavigateToUserSocial: { selectedTab in
                                onNavigateToUserSocial(
                                    SocialNavigationParams(
                                        userId: user.id,
                                        username: user.username,
                                        initialTab: selectedTab,
                                        isBusinessOrEmployee: user.isBusinessOrEmployee,
                                        followersCount: user.counters.followersCount,
                                        followingsCount: user.counters.followingsCount
                                    )
                                )
                            }
                        )
                        .padding(.vertical, .xl)

                        ProfileUserInfoView(
                            url: user.avatarURL,
                            fullName: user.fullName,
                            profession: user.profession,
                            isBusinessOrEmployee: user.isBusinessOrEmployee,
                            ratingsAverage: user.counters.ratingsAverage,
                            openingHours: user.openingHours,
                            onShowOpeningHoursSheet: onShowOpeningHours
                        )

                        actions()

                        if let owner = user.businessOwner {
                            ProfileBusinessOwnerView(
                                businessOwner: owner,
                                onNavigateToUserProfile: onNavigateToUserProfile
                            )
                        }

                        if let description = user.bio {
                            Text(description)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, .xxl)
                        }
                    }
                    .padding(.bottom, 15)

                    Section(header: customTabBar) {
                        getTabContent(for: selectedTab)
                            .id(selectedTab)
                            .transition(.opacity)
                    }
                }
            }
        }
        .onAppear {
            if let firstTab = availableTabs.first {
                selectedTab = firstTab
            }
        }
    }

    private var customTabBar: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.dividerSB)
                .frame(height: 1)
                .frame(maxWidth: .infinity)

            HStack(spacing: 20) {
                ForEach(availableTabs) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: tab.iconName)
                                .foregroundStyle(selectedTab == tab ? .primary : .secondary)

                            ZStack {
                                if selectedTab == tab {
                                    Capsule()
                                        .matchedGeometryEffect(id: "underline", in: indicatorNS)
                                        .frame(height: 3)
                                        .offset(y: 8)
                                        .foregroundColor(.primary)
                                } else {
                                    Color.clear.frame(height: 3)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
    }

    @ViewBuilder
    private func getTabContent(for tab: ProfileTab) -> some View {
        switch tab {
        case .posts:
            ProfilePostsTabView()
        case .products:
            ProfileProductsTabView()
        case .employees:
            ProfileEmployeesTabView()
        case .bookmarks:
            ProfileBookmarksTabView()
        case .info:
            ProfileInfoTabView()
        }
    }
}
