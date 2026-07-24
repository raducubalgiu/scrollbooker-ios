//
//  PostOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct PostOverlayView: View {
    var post: Post
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    var onOpenReviewsSheet: (Int) -> Void
    var onOpenLinkedProductsSheet: (Int) -> Void
    var onOpenCommentsSheet: (Int) -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .ignoresSafeArea(edges: .bottom)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 15) {
                    PostUserView(user: post.user)
                    
                    if let description = post.description {
                        PostDescriptionView(description: description)
                    }
                    
                    PostMainActionView(
                        onClick: { onOpenLinkedProductsSheet(post.id) }
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.trailing, .xxl)
                
                PostActionsView(
                    userAvatarURL: post.user.avatarURL,
                    counters: post.counters,
                    ratingsCount: post.user.ratingsCount,
                    isVideoReview: post.isVideoReview,
                    onAvatarClick: { onNavigateToUserProfile(
                        ProfileNavigationParams(
                            userId: post.user.id,
                            username: post.user.username)
                    )},
                    onLikeClick: {},
                    onReviewsClick: { onOpenReviewsSheet(post.businessOwner.id) },
                    onCommentsClick: { onOpenCommentsSheet(post.id) },
                    onBookmarksClick: {},
                    onShareClick: {}
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.leading, .m)
            .padding(.bottom, .m)
            .padding(.trailing, .s)
        }
    }
}
