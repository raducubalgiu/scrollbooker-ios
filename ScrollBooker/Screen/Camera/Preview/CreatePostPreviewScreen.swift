//
//  CreatePostPreviewScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct CreatePostPreviewScreen: View {
    let viewModel: CameraViewModel
    var onBack: () -> Void

    @Environment(SessionManager.self) private var session

    private var previewPost: Post? {
        guard let userInfo = session.userInfo else { return nil }

        let user = PostUser(
            id: userInfo.id,
            fullName: userInfo.fullName,
            username: userInfo.username,
            avatar: userInfo.avatar,
            isFollow: false,
            profession: userInfo.profession,
            ratingsAverage: 0,
            ratingsCount: 0
        )

        let businessOwner = PostBusinessOwner(
            id: userInfo.id,
            fullName: userInfo.fullName,
            username: userInfo.username,
            avatar: userInfo.avatar,
            profession: userInfo.profession,
            ratingsAverage: 0,
            ratingsCount: 0
        )

        return Post(
            id: -1,
            description: viewModel.description,
            user: user,
            businessOwner: businessOwner,
            employee: nil,
            businessLocation: nil,
            counters: PostCounters(
                commentCount: 0,
                likeCount: 0,
                bookmarkCount: 0,
                repostCount: 0,
                shareCount: 0,
                bookingsCount: 0,
                viewsCount: 0
            ),
            userActions: UserPostActions(isLiked: false, isBookmarked: false, isReposted: false),
            mediaFiles: [],
            hashtags: nil,
            isVideoReview: viewModel.isVideoReview,
            isOwnPost: true,
            businessId: userInfo.businessId,
            review: nil,
            serviceDomain: nil,
            createdAt: ""
        )
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            ZStack {
                Color.black

                if let player = viewModel.player {
                    PlayerView(player: player)
                        .allowsHitTesting(false)
                }

                if let previewPost {
                    PostOverlayView(post: previewPost, showBookButton: false)
                }
            }
            .ignoresSafeArea(edges: .top)

            header
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PostMainActionView(isDisabled: true) {}
                .padding(.horizontal, .base)
                .padding(.vertical, .s)
                .background(Color.black)
        }
        .navigationBarHidden(true)
        .task {
            viewModel.resumeOrCreatePreview()
        }
        .onDisappear {
            viewModel.pauseActivePlayer()
        }
    }

    private var header: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.35))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, .base)
        .padding(.top, .s)
    }
}
