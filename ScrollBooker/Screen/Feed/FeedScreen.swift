//
//  FeedScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedScreen: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = FeedViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    var onNavigateToFeedSearch: () -> Void
    
    let posts = dummyBookNowPosts
    
    @State private var currentIndex: Int? = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
                        ZStack {
                            if let player = viewModel.players[post.id] {
                                PlayerView(player: player)
                                
                            } else {
                                Color.black
                            }
                            
                            PostOverlayView(post: post)
                        }
                        .id(index)
                        .containerRelativeFrame(.vertical)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.never)
            .scrollPosition(id: $currentIndex)
            .ignoresSafeArea()
        }
        .onAppear {
            viewModel.prepare(posts: posts)
            viewModel.play(index: currentIndex ?? 0, in: posts)
        }
        .onChange(of: currentIndex) { _, newIndex in
           viewModel.play(index: newIndex ?? 0, in: posts)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { viewModel.pauseAll() }
            else { viewModel.play(index: currentIndex ?? 0, in: posts) }
        }
        .onDisappear { viewModel.pauseAll() }
        .background(Color.backgroundSB)
        .overlay(alignment: .top) {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    onNavigateToFeedSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }
}

#Preview("Light") {
    FeedScreen(
        onNavigateToFeedSearch: {}
    )
}

#Preview("Dark") {
    FeedScreen(
        onNavigateToFeedSearch: {}
    )
        .preferredColorScheme(.dark)
}
