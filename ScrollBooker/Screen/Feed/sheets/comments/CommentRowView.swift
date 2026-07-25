//
//  CommentRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentRowView: View {
    let item: CommentUIItem
    var onLikeClick: () -> Void
    var onReplyClick: () -> Void
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AvatarView(
                imageURL: item.user.avatarURL,
                size: .m,
                onClick: {
                    onNavigateToUserProfile(
                        ProfileNavigationParams(
                            userId: item.user.id,
                            username: item.user.username
                        )
                    )
                }
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.user.username)
                    .font(.system(size: 14, weight: .semibold))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(item.text)
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
                        Button {
                            guard !item.isLikeActionPending else { return }
                            onLikeClick()
                        } label: {
                            HStack(spacing: 6) {
                                if item.likeCount > 0 {
                                    Text("\(item.likeCount)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundColor(item.isLiked ? .red : .gray)
                                        .transition(.scale.combined(with: .opacity))
                                }

                                Image(systemName: item.isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 18))
                                    .foregroundColor(item.isLiked ? .red : .gray)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.horizontal)
        .opacity(item.isLikeActionPending ? 0.7 : 1.0)
    }
}

extension CommentRowView: Equatable {
    static func == (lhs: CommentRowView, rhs: CommentRowView) -> Bool {
        lhs.item == rhs.item
    }
}
