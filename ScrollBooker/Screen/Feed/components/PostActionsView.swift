//
//  PostActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostActionsView: View {
    var post: Post

    @Environment(\.feedActions) private var actions
    
    private func makeProfileNavigationParams() -> ProfileNavigationParams {
        ProfileNavigationParams(
            userId: post.user.id,
            username: post.user.username
        )
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if post.isVideoReview {
                AvatarView(
                    imageURL: post.user.avatarURL,
                    size: .l
                )
                .padding(.bottom, .s)
            } else {
                AvatarWithRatingView(
                    rating: 5,
                    size: .l,
                    badgeBackgroundColor: .white,
                    onClick: { actions.onNavigateToUserProfile(makeProfileNavigationParams()) }
                )
                .padding(.bottom, .m)
            }
            
            Button {
                actions.onLike(post.id)
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 28))
                        .foregroundColor(post.userActions.isLiked ? .errorSB : .white)
                    
                    Text("\(post.counters.likeCount)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            
            if !post.isVideoReview {
                Button {
                    actions.onOpenReviewsSheet(post.user.id)
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "clipboard.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                        
                        Text("\(post.user.ratingsCount)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
            
            Button {
                actions.onOpenCommentsSheet(post.id)
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "ellipsis.message.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                    
                    Text("\(post.counters.commentCount)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            
            Button {
                actions.onBookmark(post.id)
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 28))
                        .foregroundColor(post.userActions.isBookmarked ? .ratingSB : .white)
                    
                    Text("\(post.counters.bookmarkCount)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            
            Button {
                
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                    
                    Text("\(10)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
        }
    }
}
