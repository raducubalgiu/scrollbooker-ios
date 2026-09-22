//
//  BusinessSocialTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessPostsTabView: View {
    let posts: [BusinessProfileLatestPost]
    
    var body: some View {
        if posts.isEmpty {
            Text(String(localized: "message_empty_posts"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(posts) { post in
                        BusinessPostView(
                            postId: post.id,
                            mediaFiles: post.mediaFiles,
                            viewsCount: post.viewsCount,
                            onNavigateToPost: { postId in }
                        )
                    }
                }
            }
            .contentMargins(.horizontal, 16, for: .scrollContent)
        }
    }
}

