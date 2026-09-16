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
        switch controller.bookmarksState {
        case .idle, .loading:
            LoadingView(maxHeight: 500)

        case .error(let message):
            ErrorView(message: message, maxHeight: 500) {
                Task { await controller.loadInitialBookmarks(userId: userId) }
            }

        case .success(let posts):
            if posts.isEmpty {
                NoDataView(
                    title: String(localized: "title_posts"),
                    message: String(localized: "message_empty_bookmarks"),
                    maxHeight: 500,
                    systemImage: "video.circle"
                )
                .padding(.top, .xxl)
            } else {
                ProfileBookmarksSuccessView(
                    posts: posts,
                    isPaging: controller.isPagingBookmarks,
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
}
