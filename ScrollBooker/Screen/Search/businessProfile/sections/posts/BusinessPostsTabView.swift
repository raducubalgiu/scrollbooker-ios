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
            Text("Acest profil nu are nicio postare momentan.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(posts) { post in
                        PostGridView(
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

