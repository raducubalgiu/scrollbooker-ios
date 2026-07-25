//
//  CommentGroupRow.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentGroupRow: View {
    let comment: Comment
    let viewModel: CommentsViewModel
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onDismiss: () -> Void
    let onPrepareReply: (Int, Int?, String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CommentRowView(
                comment: comment,
                isLikeActionPending: viewModel.isLikeActionPending[comment.id] ?? false,
                onLikeClick: {
                    Task { await viewModel.toggleLikeComment(for: comment.id) }
                },
                onReplyClick: {
                    onPrepareReply(comment.id, nil, comment.user.username)
                },
                onNavigateToUserProfile: { clickedComment in
                    onDismiss()
                    onNavigateToUserProfile(
                        ProfileNavigationParams(
                            userId: clickedComment.userId,
                            username: clickedComment.username
                        )
                    )
                }
            )
            
            if let replies = viewModel.commentReplies[comment.id] {
                ForEach(replies, id: \.id) { reply in
                    CommentRowView(
                        comment: reply,
                        isLikeActionPending: viewModel.isLikeActionPending[reply.id] ?? false,
                        onLikeClick: {
                            Task { await viewModel.toggleLikeComment(for: reply.id) }
                        },
                        onReplyClick: {
                            onPrepareReply(comment.id, reply.id, reply.user.username)
                        },
                        onNavigateToUserProfile: { clickedReply in
                            onDismiss()
                            onNavigateToUserProfile(
                                ProfileNavigationParams(
                                    userId: clickedReply.userId,
                                    username: clickedReply.username
                                )
                            )
                        }
                    )
                    .padding(.leading, 44)
                }
            }
            
            let remaining = viewModel.remainingRepliesCount(for: comment)
            
            if remaining > 0 {
                Button {
                    Task {
                        await viewModel.loadReplies(for: comment.id)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 24, height: 1)
                        
                        if viewModel.isRepliesLoading[comment.id] == true {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text(viewModel.commentReplies[comment.id] == nil ? "Vezi toate cele \(remaining) răspunsuri" : "Vezi încă \(remaining) răspunsuri")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 44)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
    }
}
