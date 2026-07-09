//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct SocialScreen: View {
    let viewModel: SocialViewModel
    let username: String
    let isBusinessOrEmployee: Bool
    
    let initialFollowersCount: Int
    let initialFollowingsCount: Int
    
    @State private var selectedTab: SocialTab
    
    init(
        viewModel: SocialViewModel,
        username: String,
        initialTab: SocialTab,
        isBusinessOrEmployee: Bool,
        initialFollowersCount: Int,
        initialFollowingsCount: Int
    ) {
        self.viewModel = viewModel
        self.username = username
        self.isBusinessOrEmployee = isBusinessOrEmployee
        self.initialFollowersCount = initialFollowersCount
        self.initialFollowingsCount = initialFollowingsCount
        _selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
            VStack(spacing: 0) {
                Header(title: "@\(username)")
                
                SocialTabsView(
                    selectedTab: $selectedTab,
                    followersCount: initialFollowersCount,
                    followingsCount: initialFollowingsCount
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

//#Preview("Light") {
//    SocialScreen()
//}
//
//#Preview("Dark") {
//    SocialScreen()
//        .preferredColorScheme(.dark)
//}
