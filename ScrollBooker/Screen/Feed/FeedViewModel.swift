//
//  FeedViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

//import SwiftUI
//import AVKit
//import Combine
//
//class FeedViewModel: ObservableObject {
//    @Published var players: [Int: AVPlayer] = [:]
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    func prepare(posts: [Post]) {
//        for post in posts where players[post.id] == nil {
//            guard let media = post.mediaFiles.first,
//                  let url = URL(string: media.url) else {
//                continue
//            }
//            
//            let item = AVPlayerItem(url: url)
//            let p = AVPlayer(playerItem: item)
//            p.actionAtItemEnd = .none
//            
//            NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
//                .sink { [weak p] _ in
//                    p?.seek(to: .zero)
//                    p?.play()
//                }
//                .store(in: &cancellables)
//            players[post.id] = p
//        }
//    }
//    
//    func play(index: Int, in posts: [Post]) {
//        guard posts.indices.contains(index) else { return }
//        pauseAll()
//        let post = posts[index]
//        players[post.id]?.play()
//    }
//    
//    func pauseAll() {
//        players.values.forEach { $0.pause() }
//    }
//}

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
//        switch newTab {
//        case .explore:
//            followingViewModel.pauseAll()
//            exploreViewModel.playCurrent()
//        case .following:
//            exploreViewModel.pauseAll()
//            followingViewModel.playCurrent()
//        }
    }
    
    func handleScenePhase(_ phase: ScenePhase) {
//        if phase != .active {
//            exploreViewModel.pauseAll()
//            followingViewModel.pauseAll()
//        } else {
//            switch selectedTab {
//                case .explore: exploreViewModel.playCurrent()
//                case .following: followingViewModel.playCurrent()
//            }
//        }
    }
}

