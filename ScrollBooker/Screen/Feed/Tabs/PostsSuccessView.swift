//
//  PostsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct PostsSuccessView: View {
    var viewModel: BaseFeedViewModel
    @Binding var currentPostId: Int?
    var showBookButton: Bool = true

    @Environment(\.feedActions) private var actions

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.posts, id: \.id) { post in
                        ZStack {
                            Color.black

                            if let player = viewModel.player(for: post.id) {
                                PlayerView(player: player)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .allowsHitTesting(false)
                            }

                            if !viewModel.isPlayerReady(for: post.id), let firstMedia = post.mediaFiles.first {
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

                            PostOverlayView(
                                post: post,
                                showBookButton: showBookButton,
                                userCoordinates: viewModel.userCoordinates
                            )

                            // Mirrors Android's PostVerticalPager play indicator — a bare white
                            // 50%-opacity play.fill triangle, centered, fading in/out, shown only
                            // while the user has explicitly paused (never during buffering) —
                            // except sized smaller than Android's, by deliberate UX request.
                            Image(systemName: "play.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white.opacity(0.5))
                                .opacity(viewModel.isPaused(postId: post.id) ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.isPaused(postId: post.id))
                                .allowsHitTesting(false)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.togglePlayer(postId: post.id)
                        }
                        .containerRelativeFrame(.horizontal)
                        .containerRelativeFrame(.vertical)
                        // Identity is the post itself, not its screen position — a wholesale
                        // posts replacement (e.g. applying Explore filters) means slot 0 can hold
                        // a completely different post than before. Keying by position here was
                        // the root cause of stale player/thumbnail content surviving a refresh:
                        // SwiftUI recycled the row (and its embedded AVPlayerViewController)
                        // instead of tearing it down, since "index 0" looked unchanged even though
                        // the post at it wasn't.
                        .id(post.id)
                        .onAppear {
                            if post.id == viewModel.posts.first?.id
                                && viewModel.currentIndex == 0
                                && viewModel.player(for: post.id) == nil {
                                viewModel.updateWindow(at: 0)
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.never)
            .scrollPosition(id: $currentPostId)
            .onAppear {
                if let target = currentPostId, target != viewModel.posts.first?.id {
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
