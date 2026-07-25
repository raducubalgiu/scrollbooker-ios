//
//  PostActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostActionsView: View {
    var userAvatarURL: URL?
    var counters: PostCounters
    var userActions: UserPostActions
    var ratingsCount: Int
    var isVideoReview: Bool
    
    var onAvatarClick: () -> Void
    var onLikeClick: () -> Void
    var onReviewsClick: () -> Void
    var onCommentsClick: () -> Void
    var onBookmarksClick: () -> Void
    var onShareClick: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if isVideoReview {
                AvatarView(
                    imageURL: userAvatarURL,
                    size: .l
                )
                .padding(.bottom, .s)
            } else {
                AvatarWithRatingView(
                    rating: 5,
                    size: .l,
                    badgeBackgroundColor: .white,
                    onClick: onAvatarClick
                )
                .padding(.bottom, .m)
            }
            
            Button {
                onLikeClick()
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 28))
                        .foregroundColor(userActions.isLiked ? .errorSB : .white)
                    
                    Text("\(counters.likeCount)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            
            if !isVideoReview {
                Button {
                    onReviewsClick()
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Image(systemName: "clipboard.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                        
                        Text("\(ratingsCount)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
            
            Button {
                onCommentsClick()
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "ellipsis.message.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                    
                    Text("\(counters.commentCount)")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            
            Button {
                onBookmarksClick()
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 28))
                        .foregroundColor(userActions.isBookmarked ? .ratingSB : .white)
                    
                    Text("\(counters.bookmarkCount)")
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
