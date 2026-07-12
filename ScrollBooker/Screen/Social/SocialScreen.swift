//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct SocialScreen: View {
    let viewModel: SocialViewModel
    var onBack: () -> Void
    
    var username: String
    var isBusinessOrEmployee: Bool
    
    var followersCount: Int
    var followingsCount: Int
    
    @State var selectedTab: SocialTab
    
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
                
                FollowersTabView(
                    users: viewModel.followersUiState.data,
                    isLoading: viewModel.followersUiState.isLoading,
                    onLoadMore: { currentUser in
                        Task { await viewModel.loadMoreFollowersIfNeeded(currentUser: currentUser) }
                    }
                )
                .tag(SocialTab.followers)
                
                FollowingsTabView(
                    users: viewModel.followingsUiState.data,
                    isLoading: viewModel.followingsUiState.isLoading,
                    onLoadMore: { currentUser in
                        Task { await viewModel.loadMoreFollowingsIfNeeded(currentUser: currentUser) }
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
