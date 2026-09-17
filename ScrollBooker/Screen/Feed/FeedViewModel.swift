//
//  FeedViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI
import Observation

@Observable
final class FeedViewModel {
    var selectedTab: FeedTab = .explore
    
    let exploreViewModel: ExploreTabViewModel
    let followingViewModel: FollowingTabViewModel
    
    init(exploreViewModel: ExploreTabViewModel, followingViewModel: FollowingTabViewModel) {
        self.exploreViewModel = exploreViewModel
        self.followingViewModel = followingViewModel
    }
    
    func handleTabChange(to newTab: FeedTab) {
        selectedTab = newTab
        switch newTab {
            case .explore:
                followingViewModel.pauseAll()
                exploreViewModel.playCurrent()
            case .following:
                exploreViewModel.pauseAll()
                followingViewModel.playCurrent()
            }
    }

    /// `isFeedVisible` — whether the Feed tab is actually what's on screen right now (selected
    /// tab AND at the root of its own NavigationStack, not pushed into some other screen reached
    /// from Feed). Backgrounding/foregrounding says nothing about that on its own, so without this
    /// check, returning from the background always resumed Explore/Following's video regardless of
    /// what the user was actually looking at.
    func handleScenePhase(_ phase: ScenePhase, isFeedVisible: Bool) {
        if phase != .active {
            exploreViewModel.pauseAll()
            followingViewModel.pauseAll()
        } else if isFeedVisible {
            switch selectedTab {
                case .explore: exploreViewModel.playCurrent()
                case .following: followingViewModel.playCurrent()
            }
        }
    }
}

