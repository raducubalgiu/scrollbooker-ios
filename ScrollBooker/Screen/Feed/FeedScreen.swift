//
//  FeedScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedScreen: View {
    @StateObject private var viewModel = FeedViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    private let videos: [Video] = [
        Video(id: "1", url: URL(string: "https://media.scrollbooker.ro/video-post-6.mp4")!),
        Video(id: "2", url: URL(string: "https://media.scrollbooker.ro/frizerie-2.mov")!),
        Video(id: "3", url: URL(string: "https://media.scrollbooker.ro/frizerie-7.mp4")!),
        Video(id: "4", url: URL(string: "https://media.scrollbooker.ro/frizerie-8.mp4")!)
    ]
    
    @State private var currentIndex: Int? = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(Array(videos.enumerated()), id: \.offset) { index, video in
                    ZStack {
                        if let player = viewModel.players[video.id] {
                            PlayerView(player: player).ignoresSafeArea()
                            
                        } else {
                            Color.black
                        }
                        
//                        VStack {
//                            HStack {
//                                Image(Image(systemName: "menu"))
//                                Image(Image(systemName: "search"))
//                            }
//                            
//                            PostOverlayView()
//                        }
//                        .frame(maxHeight: .infinity)
                    }
                    .id(index)
                    .containerRelativeFrame(.vertical)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)
        .ignoresSafeArea()
        .onAppear {
            viewModel.prepare(videos: videos)
            viewModel.play(index: currentIndex ?? 0, in: videos)
        }
        .onChange(of: currentIndex) { _, newIndex in
           viewModel.play(index: newIndex ?? 0, in: videos)
        }
        .scrollPosition(id: $currentIndex)
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { viewModel.pauseAll() }
            else { viewModel.play(index: currentIndex ?? 0, in: videos) }
        }
        .onDisappear { viewModel.pauseAll() }
        .background(Color.backgroundSB)
    }
}

#Preview("Light") {
    FeedScreen()
}

#Preview("Dark") {
    FeedScreen()
        .preferredColorScheme(.dark)
}
