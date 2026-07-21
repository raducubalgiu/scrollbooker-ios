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

    var onNavigateToFeedSearch: () -> Void
    let posts = dummyBookNowPosts
    @State private var currentIndex: Int? = 0

    var body: some View {
        GeometryReader { globalGeo in
//            let videoHeight = globalGeo.size.height
//            let videoWidth = globalGeo.size.width
//
//            ScrollView(.vertical) {
//                LazyVStack(spacing: 0) {
//                    ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
//                        ZStack {
//                            if let player = viewModel.players[post.id] {
//                                PlayerView(player: player)
//                            } else {
//                                Color.black
//                            }
//
//                            PostOverlayView(post: post)
//                        }
//                        .frame(width: videoWidth, height: videoHeight)
//                        .id(index)
//                    }
//                }
//                .scrollTargetLayout()
//            }
//            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
//            .scrollIndicators(.never)
//            .scrollPosition(id: $currentIndex)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.black)
//        .overlay(alignment: .top) {
//            FeedHeaderView(onNavigateToFeedSearch: onNavigateToFeedSearch)
//        }
//        .onAppear {
//            viewModel.prepare(posts: posts)
//            viewModel.play(index: currentIndex ?? 0, in: posts)
//        }
//        .onChange(of: currentIndex) { _, newIndex in
//           viewModel.play(index: newIndex ?? 0, in: posts)
//        }
//        .onChange(of: scenePhase) { _, phase in
//            if phase != .active { viewModel.pauseAll() }
//            else { viewModel.play(index: currentIndex ?? 0, in: posts) }
//        }
//        .onDisappear { viewModel.pauseAll() }
    }
}

