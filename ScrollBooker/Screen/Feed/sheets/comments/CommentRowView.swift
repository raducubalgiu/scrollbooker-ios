//
//  CommentRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentRowView: View {
    let comment: Comment
    let isLikeActionPending: Bool
    var onLikeClick: () -> Void
    var onReplyClick: () -> Void
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AvatarView(
                imageURL: comment.user.avatarURL,
                size: .s,
                onClick: {
                    onNavigateToUserProfile(
                        ProfileNavigationParams(
                            userId: comment.user.id,
                            username: comment.user.username
                        )
                    )
                }
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.user.username)
                    .font(.system(size: 14, weight: .semibold))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(comment.text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(alignment: .center) {
                    HStack(spacing: 16) {
                        Text("2d")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                        
                        Button {
                            onReplyClick()
                        } label: {
                            Text("Reply")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
//                        if comment.likedbyPostAuthor {
//                            AvatarView(
//                                imageURL: "",
//                                size: .xs
//                            )
//                        }
                        
                        Button {
                            guard !isLikeActionPending else { return }
                            onLikeClick()
                        } label: {
                            HStack(spacing: 6) {
                                if comment.likeCount > 0 {
                                    Text("\(comment.likeCount)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundColor(comment.isLiked ? .red : .gray)
                                        .transition(.scale.combined(with: .opacity))
                                }
                                
                                Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 18))
                                    .foregroundColor(comment.isLiked ? .red : .gray)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.horizontal)
        .opacity(isLikeActionPending ? 0.7 : 1.0)
    }
}

