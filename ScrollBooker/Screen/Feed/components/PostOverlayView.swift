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
    
    var onLike: (Int) -> Void
    var onBookmark: (Int) -> Void
    
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
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    PostUserView(user: post.user)
                    
                    if let description = post.description {
                        PostDescriptionView(description: description)
                    }
                    
                    PostMainActionView(
                        onClick: { onOpenLinkedProductsSheet(post.id) }
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, .base)
                
                PostActionsView(
                    userAvatarURL: post.user.avatarURL,
                    counters: post.counters,
                    userActions: post.userActions,
                    ratingsCount: post.user.ratingsCount,
                    isVideoReview: post.isVideoReview,
                    onAvatarClick: { onNavigateToUserProfile(
                        ProfileNavigationParams(
                            userId: post.user.id,
                            username: post.user.username)
                    )},
                    onLikeClick: { onLike(post.id) },
                    onReviewsClick: { onOpenReviewsSheet(post.user.id) },
                    onCommentsClick: { onOpenCommentsSheet(post.id) },
                    onBookmarksClick: { onBookmark(post.id) },
                    onShareClick: {}
                )
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.leading, .m)
            .padding(.bottom, .m)
            .padding(.trailing, .s)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

