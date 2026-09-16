//
//  ProfilePostsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfilePostsTabView: View {
    let controller: ProfileController
    let userId: Int
    let onNavigateToPost: (Int) -> Void

    var body: some View {
        switch controller.postsState {
            case .idle, .loading:
                LoadingView(maxHeight: 500)

            case .error(let message):
                ErrorView(message: message, maxHeight: 500) {
                    Task { await controller.loadInitialPosts(userId: userId) }
                }

            case .success(let posts):
                if posts.isEmpty {
                    NoDataView(
                        title: String(localized: "title_posts"),
                        message: String(localized: "message_empty_posts"),
                        maxHeight: 500,
                        systemImage: "video.circle"
                    )
                    .padding(.top, .xxl)
                } else {
                    ProfilePostsSuccessView(
                        posts: posts,
                        isPaging: controller.isPagingPosts,
                        onLoadMore: { currentPost in
                            Task {
                                await controller.loadMorePostsIfNeeded(userId: userId, currentPost: currentPost)
                            }
                        },
                        onNavigateToPost: onNavigateToPost
                    )
                }
            }
    }
}
