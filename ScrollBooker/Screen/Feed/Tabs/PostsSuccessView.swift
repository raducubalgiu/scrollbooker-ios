//
//  PostsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct PostsSuccessView: View {
    var viewModel: BaseFeedViewModel
    @Binding var currentIndex: Int?
    var showBookButton: Bool = true

    @Environment(\.feedActions) private var actions

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, _ in
                        let post = viewModel.posts[index]

                        ZStack {
                            Color.black

                            if let firstMedia = post.mediaFiles.first {
                                GeometryReader { geometry in
                                    AsyncImage(url: URL(string: firstMedia.thumbnailUrl ?? "")) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .clipped()
                                        default:
                                            Color.black
                                        }
                                    }
                                }
                                .ignoresSafeArea()
                            }

                            if let player = viewModel.players[post.id] {
                                PlayerView(player: player)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .allowsHitTesting(false)
                            }

                            PostOverlayView(post: post, showBookButton: showBookButton)
                        }
                        .containerRelativeFrame(.horizontal)
                        .containerRelativeFrame(.vertical)
                        .id(index)
                        .onAppear {
                            if index == 0 && viewModel.currentIndex == 0 && viewModel.players[post.id] == nil {
                                viewModel.updateWindow(at: 0)
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.never)
            .scrollPosition(id: $currentIndex)
            .onAppear {
                if let target = currentIndex, target != 0 {
                    proxy.scrollTo(target, anchor: .top)
                }
            }
            .refreshable {
                if let exploreVM = viewModel as? ExploreTabViewModel {
                    await exploreVM.refreshPosts()
                } else if let followingVM = viewModel as? FollowingTabViewModel {
                    await followingVM.refreshPosts()
                }
            }
        }
    }
}
