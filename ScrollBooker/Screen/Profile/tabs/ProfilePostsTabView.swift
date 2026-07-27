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
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    var body: some View {
        switch controller.postsViewState {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)

            case .empty:
                NoDataView(
                    title: "no posts", message: "noPosts"
                )

            case .error(let message):
                ErrorView(message: message) {
                    Task { await controller.loadInitialPosts(userId: userId) }
                }
                .frame(maxWidth: .infinity, minHeight: 200)

            case .success(let posts):
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(posts, id: \.id) { post in
                        PostGridView(
                            postId: post.id,
                            mediaFiles: post.mediaFiles,
                            viewsCount: post.counters.viewsCount,
                            onNavigateToPost: { postId in }
                        )
                        .onAppear {
                            Task { await controller.loadMorePostsIfNeeded(userId: userId, currentPost: post) }
                        }
                    }
                }

                if controller.isPagingPosts {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }
    }
}
