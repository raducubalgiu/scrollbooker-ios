//
//  FeedViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI
import AVKit
import Combine

struct Video: Identifiable {
    let id: String
    let url: URL
}

class FeedViewModel: ObservableObject {
    @Published var players: [String: AVPlayer] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    func prepare(videos: [Video]) {
        for v in videos where players[v.id] == nil {
            let item = AVPlayerItem(url: v.url)
            let p = AVPlayer(playerItem: item)
            p.actionAtItemEnd = .none
            
            NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
                .sink { [weak p] _ in
                    p?.seek(to: .zero)
                    p?.play()
                }
                .store(in: &cancellables)
            players[v.id] = p
        }
    }
    
    func play(index: Int, in videos: [Video]) {
        guard videos.indices.contains(index) else { return }
        pauseAll()
        let v = videos[index]
        players[v.id]?.play()
    }
    
    func pauseAll() {
        players.values.forEach { $0.pause() }
    }
}
