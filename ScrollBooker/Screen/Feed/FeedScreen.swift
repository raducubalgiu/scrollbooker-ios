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
        // Corecție: Eliminăm State(initialValue:) deoarece clasa este deja administrată global prin @Observable
        self.viewModel = viewModel
        self.onNavigateToFeedSearch = onNavigateToFeedSearch
        self.onNavigateToUserProfile = onNavigateToUserProfile
        self.onNavigateToBooking = onNavigateToBooking
        self.makeCommentsVM = makeCommentsVM
        self.makeLinkedProductsVM = makeLinkedProductsVM
        self.makeReviewsVM = makeReviewsVM
    }

    var body: some View {
        // Declarăm local contextul Bindable pentru macro-ul @Observable
        @Bindable var bindableViewModel = viewModel
        
        ZStack {
            // Sincronizare perfectă bidirecțională prin $bindableViewModel
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
                    // Când se apasă pe butoanele din header, mutăm direct starea (declanșând automat logica de pauză)
                    viewModel.handleTabChange(to: newTab)
                },
                onNavigateToFeedSearch: onNavigateToFeedSearch
            )
        }
        // Prinde swipe-ul fizic de pe ecran și execută logica de mutare a ferestrelor audio
        .onChange(of: viewModel.selectedTab) { _, newTab in
            viewModel.handleTabChange(to: newTab)
        }
        // Gestiunea background / foreground pe telefon
        .onChange(of: scenePhase) { _, phase in
            viewModel.handleScenePhase(phase)
        }
    }
}
