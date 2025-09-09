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
        GeometryReader { geo in
            let totalHeight = geo.size.height - 56 + geo.safeAreaInsets.top

            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
                        ZStack {
                            VStack(spacing: 0) {
                                ZStack {
                                    if let player = viewModel.players[post.id] {
                                        PlayerView(player: player)
                                            
                                    }
                                    
                                    PostOverlayView(post: post)
                                }
                                .frame(height: totalHeight)
                                
                                Spacer(minLength: 0)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .containerRelativeFrame(.vertical)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .ignoresSafeArea(edges: .top)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.never)
            .scrollPosition(id: $currentIndex)
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
            .background(Color.black)
            .overlay(alignment: .top) {
                FeedHeaderView(onNavigateToFeedSearch: onNavigateToFeedSearch)
            }
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
