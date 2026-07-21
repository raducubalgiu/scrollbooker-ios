//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct SocialScreen: View {
    @State var viewModel: SocialViewModel
    var onBack: () -> Void
    
    var username: String
    var isBusinessOrEmployee: Bool
    
    var followersCount: Int
    var followingsCount: Int
    
    @State var selectedTab: SocialTab
    
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: "@\(username)",
                onBack: onBack
            )
            
            SocialTabsView(
                selectedTab: $selectedTab,
                followersCount: followersCount,
                followingsCount: followingsCount
            )
            
            TabView(selection: $selectedTab) {
                Text("Recenzii")
                    .tag(SocialTab.reviews)
                
                SocialUsersTabView(
                    state: viewModel.followersState,
                    noDataTitle: "Urmăritori",
                    noDataMessage: "Nu există urmăritori",
                    onRefresh: { await viewModel.refresh(tab: .followers) },
                    onLoadMore: { currentUser in
                        Task { await viewModel.loadMoreFollowersIfNeeded(currentUser: currentUser) }
                    },
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onFollow: { user in
                        Task { await viewModel.toggleFollowStatus(for: user) }
                    }
                )
                .tag(SocialTab.followers)
                
                SocialUsersTabView(
                    state: viewModel.followingsState,
                    noDataTitle: "Urmărește",
                    noDataMessage: "Nu urmărești pe nimeni momentan",
                    onRefresh: { await viewModel.refresh(tab: .following) },
                    onLoadMore: { currentUser in
                        Task { await viewModel.loadMoreFollowingsIfNeeded(currentUser: currentUser) }
                    },
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onFollow: { user in
                        Task { await viewModel.toggleFollowStatus(for: user) }
                    }
                )
                .tag(SocialTab.following)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.backgroundSB)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadTabIfNeeded(tab: selectedTab)
        }
        .onChange(of: selectedTab) { _, newTab in
            Task {
                await viewModel.loadTabIfNeeded(tab: newTab)
            }
        }
    }
}
