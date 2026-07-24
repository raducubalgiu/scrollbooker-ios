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
    
    init(viewModel: FeedViewModel, onNavigateToFeedSearch: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onNavigateToFeedSearch = onNavigateToFeedSearch
    }

    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                ExploreTab(viewModel: viewModel.exploreViewModel)
                    .tag(FeedTab.explore)
                
                FollowingTab(viewModel: viewModel.followingViewModel)
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

