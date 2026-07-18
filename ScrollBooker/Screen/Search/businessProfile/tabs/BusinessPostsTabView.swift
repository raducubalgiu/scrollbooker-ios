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
        VStack(alignment: .leading) {
            Text(String(localized: "posts"))
                .font(.title2.weight(.heavy))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                .padding(.horizontal, .base)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
