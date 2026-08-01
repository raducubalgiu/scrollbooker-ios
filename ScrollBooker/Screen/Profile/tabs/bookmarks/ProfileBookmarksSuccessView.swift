//
//  ProfileBookmarksSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct ProfileBookmarksSuccessView: View {
    let posts: [Post]
    let isPaging: Bool
    
    var onLoadMore: (Post) -> Void
    var onNavigateToPost: (Int) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        VStack(spacing: 1) {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(posts, id: \.id) { post in
                    PostGridView(
                        postId: post.id,
                        mediaFiles: post.mediaFiles,
                        viewsCount: post.counters.viewsCount,
                        onNavigateToPost: onNavigateToPost
                    )
                    .onAppear {
                        onLoadMore(post)
                    }
                }
            }
            
            if isPaging {
                LoadMoreView()
            }
        }
    }
}
