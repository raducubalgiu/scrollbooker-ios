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
                    url: post.user.avatarURL,
                    rating: post.user.ratingsAverage,
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
                    Image(systemName: post.userActions.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 27))
                        .foregroundColor(post.userActions.isLiked ? .errorSB : .white)
                        .actionIconShadow()

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
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 27))
                            .foregroundColor(.white)
                            .actionIconShadow()

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
                    Image(systemName: "ellipsis.message")
                        .font(.system(size: 27))
                        .foregroundColor(.white)
                        .actionIconShadow()

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
                    Image(systemName: post.userActions.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 27))
                        .foregroundColor(post.userActions.isBookmarked ? .ratingSB : .white)
                        .actionIconShadow()

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
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.system(size: 27))
                        .foregroundColor(.white)
                        .actionIconShadow()

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

private extension View {
    func actionIconShadow() -> some View {
        self.shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 1)
    }
}
