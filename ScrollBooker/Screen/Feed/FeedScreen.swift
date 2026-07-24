//
//  FeedScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedScreen: View {
    @State private var viewModel: FeedViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var onNavigateToFeedSearch: () -> Void
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    
    let makeCommentsVM: (Int) -> CommentsViewModel
    let makeLinkedProductsVM: (Int) -> LinkedProductsViewModel
    
    init(
        viewModel: FeedViewModel,
        onNavigateToFeedSearch: @escaping () -> Void,
        onNavigateToUserProfile: @escaping (ProfileNavigationParams) -> Void,
        onNavigateToBooking: @escaping (BookingNavigationParams) -> Void,
        makeCommentsVM: @escaping (Int) -> CommentsViewModel,
        makeLinkedProductsVM: @escaping (Int) -> LinkedProductsViewModel,
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onNavigateToFeedSearch = onNavigateToFeedSearch
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToBooking = onNavigateToBooking
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
    }

    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                ExploreTab(
                    viewModel: viewModel.exploreViewModel,
                    makeCommentsVM: makeCommentsVM,
                    makeLinkedProductsVM: makeLinkedProductsVM,
                    onNavigateToUserProfile: onNavigateToUserProfile,
                    onNavigateToBooking: onNavigateToBooking
                )
                    .tag(FeedTab.explore)
                
                FollowingTab(
                    viewModel: viewModel.followingViewModel,
                    makeCommentsVM: makeCommentsVM,
                    makeLinkedProductsVM: makeLinkedProductsVM,
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
                selectedTab: Bindable(viewModel).selectedTab,
                onNavigateToFeedSearch: onNavigateToFeedSearch
            )
        }
        .onChange(of: viewModel.selectedTab) { _, newTab in
            viewModel.handleTabChange(to: newTab)
        }
        .onChange(of: scenePhase) { _, phase in
            viewModel.handleScenePhase(phase)
        }
    }
}

