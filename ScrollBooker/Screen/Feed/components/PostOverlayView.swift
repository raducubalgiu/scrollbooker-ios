//
//  PostOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct PostOverlayView: View {
    var post: Post
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 15) {
                PostUserView(user: post.user)
                
                if let product = post.product {
                   PostProductView(product: product)
                }
                
                if let description = post.description {
                    PostDescriptionView(description: description)
                }
                
                PostMainActionView(onClick: {})
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, .xxl)
            
            PostActionsView(
                userAvatarURL: post.user.avatarURL,
                counters: post.counters
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.leading)
        .padding(.bottom)
    }
}

#Preview("Post Overlay") {
    PostOverlayView(
        post: dummyBookNowPosts[1]
    )
        .preferredColorScheme(.dark)
}
