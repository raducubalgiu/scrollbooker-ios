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
    
    var body: some View {
        switch controller.postsViewState {
            case .idle, .loading:
                LoadingView(maxHeight: 500)

            case .empty:
                NoDataView(
                    title: String(localized: "posts"),
                    message: String(localized: "notFoundPosts"),
                    maxHeight: 500
                )

            case .error(let message):
                ErrorView(message: message, maxHeight: 500) {
                    Task { await controller.loadInitialPosts(userId: userId) }
                }

            case .success(let posts):
                ProfilePostsSuccessView(
                    posts: posts,
                    isPaging: controller.isPagingPosts,
                    onLoadMore: { currentPost in
                        Task {
                            await controller.loadMorePostsIfNeeded(userId: userId, currentPost: currentPost)
                        }
                    },
                    onNavigateToPost: { postId in }
                )
            }
        
    }
}
