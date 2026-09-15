//
//  CommentGroupRow.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentGroupRow: View {
    let item: CommentUIItem
    let viewModel: CommentsViewModel
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onDismiss: () -> Void
    let onPrepareReply: (Int, Int?, String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CommentRowView(
                item: item,
                onLikeClick: {
                    Task { await viewModel.toggleLikeComment(for: item.id) }
                },
                onReplyClick: {
                    onPrepareReply(item.id, nil, item.user.username)
                },
                onNavigateToUserProfile: { clicked in
                    onDismiss()
                    onNavigateToUserProfile(
                        ProfileNavigationParams(
                            userId: clicked.userId,
                            username: clicked.username
                        )
                    )
                }
            )
            .equatable()

            ForEach(item.repliesState.loadedReplies, id: \.id) { reply in
                CommentRowView(
                    item: reply,
                    onLikeClick: {
                        Task { await viewModel.toggleLikeComment(for: reply.id) }
                    },
                    onReplyClick: {
                        onPrepareReply(item.id, reply.id, reply.user.username)
                    },
                    onNavigateToUserProfile: { clicked in
                        onDismiss()
                        onNavigateToUserProfile(
                            ProfileNavigationParams(
                                userId: clicked.userId,
                                username: clicked.username
                            )
                        )
                    }
                )
                .equatable()
                .padding(.leading, 44)
                .padding(.top)
            }

            if item.remainingRepliesCount > 0 {
                Button {
                    Task { await viewModel.loadReplies(for: item.id) }
                } label: {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 24, height: 1)

                        if item.repliesState.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text(
                                item.repliesState.loadedReplies.isEmpty
                                    ? "Vezi toate cele \(item.remainingRepliesCount) răspunsuri"
                                    : "Vezi încă \(item.remainingRepliesCount) răspunsuri"
                            )
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

extension CommentGroupRow: Equatable {
    static func == (lhs: CommentGroupRow, rhs: CommentGroupRow) -> Bool {
        lhs.item == rhs.item
    }
}
