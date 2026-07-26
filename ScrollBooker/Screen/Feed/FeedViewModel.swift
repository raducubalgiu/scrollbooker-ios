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

    func handleScenePhase(_ phase: ScenePhase) {
        if phase != .active {
            exploreViewModel.pauseAll()
            followingViewModel.pauseAll()
        } else {
            switch selectedTab {
                case .explore: exploreViewModel.playCurrent()
                case .following: followingViewModel.playCurrent()
            }
        }
    }
}

