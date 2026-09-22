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
    let onOpenDrawer: () -> Void

    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Post) -> LinkedProductsViewModel
    let makeReviewsVM: (Post) -> ReviewsViewModel
    let makeStatisticsVM: (Int) -> PostStatisticsViewModel
    let makeDeletePostVM: () -> DeletePostViewModel
    let makeEditPostVM: (Post) -> EditPostViewModel

    init(
        viewModel: FeedViewModel,
        onNavigateToFeedSearch: @escaping () -> Void,
        onNavigateToUserProfile: @escaping (ProfileNavigationParams) -> Void,
        onNavigateToBooking: @escaping (BookingNavigationParams) -> Void,
        onOpenDrawer: @escaping () -> Void,
        makeCommentsVM: @escaping (Int) -> CommentsViewModel,
        makeLinkedProductsVM: @escaping (Post) -> LinkedProductsViewModel,
        makeReviewsVM: @escaping (Post) -> ReviewsViewModel,
        makeStatisticsVM: @escaping (Int) -> PostStatisticsViewModel,
        makeDeletePostVM: @escaping () -> DeletePostViewModel,
        makeEditPostVM: @escaping (Post) -> EditPostViewModel
    ) {
        self.viewModel = viewModel
        self.onNavigateToFeedSearch = onNavigateToFeedSearch
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToBooking = onNavigateToBooking
        self.onOpenDrawer = onOpenDrawer
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
        self.makeReviewsVM = makeReviewsVM
        self.makeStatisticsVM = makeStatisticsVM
        self.makeDeletePostVM = makeDeletePostVM
        self.makeEditPostVM = makeEditPostVM
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
                    makeStatisticsVM: makeStatisticsVM,
                    makeDeletePostVM: makeDeletePostVM,
                    makeEditPostVM: makeEditPostVM,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )
                .tag(FeedTab.explore)

                FollowingTab(
                    viewModel: viewModel.followingViewModel,
                    makeCommentsVM: makeCommentsVM,
                    makeLinkedProductsVM: makeLinkedProductsVM,
                    makeReviewsVM: makeReviewsVM,
                    makeStatisticsVM: makeStatisticsVM,
                    makeDeletePostVM: makeDeletePostVM,
                    makeEditPostVM: makeEditPostVM,
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
                onChangeTab: { newTab in viewModel.handleTabChange(to: newTab) },
                onNavigateToFeedSearch: onNavigateToFeedSearch,
                onOpenDrawer: onOpenDrawer,
                activeFiltersCount: viewModel.exploreViewModel.activeFiltersCount
            )
        }
        .onChange(of: viewModel.selectedTab) { _, newTab in
            viewModel.handleTabChange(to: newTab)
        }
        .onChange(of: scenePhase) { _, phase in
            let isFeedVisible = router.selectedTab == .feed && router.feedPath.isEmpty
            viewModel.handleScenePhase(phase, isFeedVisible: isFeedVisible)
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
