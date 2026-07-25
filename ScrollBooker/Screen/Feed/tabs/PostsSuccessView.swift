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
