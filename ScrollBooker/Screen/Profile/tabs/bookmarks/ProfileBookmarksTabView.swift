//
//  ProfileBookmarksTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileBookmarksTabView: View {
    let controller: ProfileController
    let userId: Int

    var body: some View {
        switch controller.bookmarksViewState {
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
                Task { await controller.loadInitialBookmarks(userId: userId) }
            }

        case .success(let posts):
            ProfileBookmarksSuccessView(
                posts: posts,
                isPaging: controller.isPagingPosts,
                onLoadMore: { currentPost in
                    Task {
                        await controller.loadMoreBookmarksIfNeeded(
                            userId: userId,
                            currentPost: currentPost
                        )
                    }
                },
                onNavigateToPost: { postId in }
            )
        }
    }
}
