//
//  PostUserView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostUserView: View {
    var user: PostUser
    var serviceDomain: PostServiceDomain?
    var isVideoReview: Bool
    var businessOwner: PostBusinessOwner
    var employee: PostEmployee?
    var onNavigateToUser: (ProfileNavigationParams) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
            PostBadgesView(isVideoReview: isVideoReview, serviceDomain: serviceDomain)

            VStack(alignment: .leading, spacing: 5) {
                Text(user.fullName)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if isVideoReview {
                    let reviewedId = employee?.id ?? businessOwner.id
                    let reviewedUsername = employee?.username ?? businessOwner.username
                    let reviewedFullName = employee?.fullName ?? businessOwner.fullName

                    HStack(spacing: 2) {
                        PostSecondaryText(
                            text: String(localized: "leftReviewForPrefix"),
                            color: .white,
                            weight: .regular
                        )

                        PostSecondaryText(
                            text: reviewedFullName,
                            color: .white,
                            weight: .bold
                        )
                        .onTapGesture {
                            onNavigateToUser(ProfileNavigationParams(userId: reviewedId, username: reviewedUsername))
                        }
                    }
                } else {
                    PostSecondaryText(text: user.profession)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onNavigateToUser(ProfileNavigationParams(userId: user.id, username: user.username))
            }
        }
    }
}

private struct PostSecondaryText: View {
    let text: String
    var color: Color = Color.primarySB.opacity(0.85)
    var weight: Font.Weight = .semibold

    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .fontWeight(weight)
            .tracking(0.25)
            .foregroundColor(color)
            .shadow(color: .black.opacity(0.6), radius: 3, x: 1, y: 1)
    }
}
