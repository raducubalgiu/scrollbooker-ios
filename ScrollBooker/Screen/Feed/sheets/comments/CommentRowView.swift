//
//  CommentRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentRowView: View {
    let comment: Comment
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AvatarView(
                imageURL: comment.user.avatarURL,
                size: .xs,
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
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(comment.text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(alignment: .center) {
                    HStack(spacing: 16) {
                        Text("2d")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        Button {

                        } label: {
                            Text("Reply")
                                .font(.subheadline)
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
                            
                        } label: {
                            HStack(spacing: 6) {
                                if comment.likeCount > 0 {
                                    Text("\(comment.likeCount)")
                                        .font(.body)
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
    }
}
