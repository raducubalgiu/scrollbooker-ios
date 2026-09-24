//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct SocialScreen: View {
    @State var viewModel: SocialViewModel
    let reviewsViewModel: ReviewsViewModel?
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
                Group {
                    if let reviewsViewModel {
                        ReviewsSectionView(viewModel: reviewsViewModel)
                    } else {
                        NoDataView(
                            title: String(localized: "reviews"),
                            message: String(localized: "message_empty_reviews"),
                            systemImage: "star.bubble"
                        )
                    }
                }
                .tag(SocialTab.reviews)
                
                SocialUsersTabView(
                    state: viewModel.followersState,
                    hasMore: viewModel.hasMoreFollowers,
                    isPaging: viewModel.isPagingFollowers,
                    noDataTitle: String(localized: "followers"),
                    noDataMessage: String(localized: "message_empty_followers"),
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
                    hasMore: viewModel.hasMoreFollowings,
                    isPaging: viewModel.isPagingFollowings,
                    noDataTitle: String(localized: "following"),
                    noDataMessage: String(localized: "message_empty_followings"),
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
