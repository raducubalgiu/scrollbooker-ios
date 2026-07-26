//
//  FeedScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedScreen: View {
    var viewModel: FeedViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Router.self) private var router
    
    var onNavigateToFeedSearch: () -> Void
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Int) -> LinkedProductsViewModel
    let makeReviewsVM: (Int) -> ReviewsViewModel
    
    init(
        viewModel: FeedViewModel,
        onNavigateToFeedSearch: @escaping () -> Void,
        onNavigateToUserProfile: @escaping (ProfileNavigationParams) -> Void,
        onNavigateToBooking: @escaping (BookingNavigationParams) -> Void,
        makeCommentsVM: @escaping (Int) -> CommentsViewModel,
        makeLinkedProductsVM: @escaping (Int) -> LinkedProductsViewModel,
        makeReviewsVM: @escaping (Int) -> ReviewsViewModel
    ) {
        self.viewModel = viewModel
        self.onNavigateToFeedSearch = onNavigateToFeedSearch
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToBooking = onNavigateToBooking
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
        self.makeReviewsVM = makeReviewsVM
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel
        
        ZStack {
            TabView(selection: $bindableViewModel.selectedTab) {
                ExploreTab(
                    viewModel: viewModel.exploreViewModel,
                    makeCommentsVM: makeCommentsVM,
                    makeLinkedProductsVM: makeLinkedProductsVM,
                    makeReviewsVM: makeReviewsVM,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )
                .tag(FeedTab.explore)
                
                FollowingTab(
                    viewModel: viewModel.followingViewModel,
                    makeCommentsVM: makeCommentsVM,
                    makeLinkedProductsVM: makeLinkedProductsVM,
                    makeReviewsVM: makeReviewsVM,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )
                .tag(FeedTab.following)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .top) {
            FeedHeaderView(
                selectedTab: viewModel.selectedTab,
                onChangeTab: { newTab in
                    viewModel.handleTabChange(to: newTab)
                },
                onNavigateToFeedSearch: onNavigateToFeedSearch
            )
        }
        .onChange(of: viewModel.selectedTab) { _, newTab in
            viewModel.handleTabChange(to: newTab)
        }
        .onChange(of: scenePhase) { _, phase in
            viewModel.handleScenePhase(phase)
        }
        .onChange(of: router.selectedTab) { oldValue, newValue in
            if newValue == .feed {
                switch viewModel.selectedTab {
                    case .explore:
                        viewModel.exploreViewModel.playCurrent()
                    case .following:
                        viewModel.followingViewModel.playCurrent()
                    }
            } else if oldValue == .feed {
                viewModel.exploreViewModel.pauseAll()
                viewModel.followingViewModel.pauseAll()
            }
        }
    }
}
