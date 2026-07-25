//
//  PostsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct PostsSuccessView: View {
    var viewModel: BaseFeedViewModel
    
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    @Binding var currentIndex: Int?
    @Binding var activeSheet: FeedSheetType?
    
    var onLike: (Int) -> Void
    var onBookmark: (Int) -> Void

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, _ in
                    let post = viewModel.posts[index]
                    
                    ZStack {
                        Color.black
                        
                        if let firstMedia = post.mediaFiles.first {
                            GeometryReader { geometry in
                                AsyncImage(url: URL(string: firstMedia.thumbnailUrl)) { phase in
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

                        // 2. Stratul Video: Randăm PlayerView doar dacă există o instanță activă în Sliding Window
                        if let player = viewModel.players[post.id] {
                            PlayerView(player: player)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                // Oprim interacțiunea tactilă directă cu playerul nativ Apple (previne Play/Pause accidental)
                                .allowsHitTesting(false)
                        }
                        
                        // 3. Stratul de Interfață: Textele, acțiunile și butoanele peste videoclip
                        PostOverlayView(
                            post: post,
                            onNavigateToUserProfile: onNavigateToUserProfile,
                            onOpenReviewsSheet: { activeSheet = .reviews(userId: $0) },
                            onOpenLinkedProductsSheet: { activeSheet = .linkedProducts(postId: $0) },
                            onOpenCommentsSheet: { activeSheet = .comments(postId: $0) },
                            onLike: onLike,
                            onBookmark: onBookmark
                        )
                    }
                    .containerRelativeFrame(.horizontal)
                    .containerRelativeFrame(.vertical)
                    .id(index)
                    .onAppear {
                        // Edge-case pentru prima pornire: dacă este prima celulă (index 0) și fereastra nu s-a activat încă,
                        // forțăm recalcularea ferestrei glisante pentru a porni primul video instant.
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
        .refreshable {
            if let exploreVM = viewModel as? ExploreTabViewModel {
                await exploreVM.refreshPosts()
            } else if let followingVM = viewModel as? FollowingTabViewModel {
                await followingVM.refreshPosts()
            }
        }
    }
}
