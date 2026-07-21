//
//  UserListItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct UserListItem: View {
    var userSocial: UserSocial
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    var onFollow: (UserSocial) -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                if(userSocial.isBusinessOrEmployee) {
                    AvatarWithRatingView(
                        url: URL(string: userSocial.avatar ?? ""),
                        rating: userSocial.ratingsAverage,
                        size: .l
                    )
                } else {
                    AvatarView(
                        imageURL: URL(string: userSocial.avatar ?? ""),
                        size: .l,
                    )
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(userSocial.fullName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("@\(userSocial.username)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Button {
                    onFollow(userSocial)
                } label: {
                    Text(userSocial.isFollow ? "following" : "follow")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(userSocial.isFollow ? .onBackgroundSB : .onPrimarySB)
                }
                .padding(.vertical, .s)
                .padding(.horizontal, .m)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(userSocial.isFollow ? Color.backgroundSB : Color.primarySB)
                        .stroke(userSocial.isFollow ? .dividerSB : Color.primarySB, lineWidth: 1)
                )
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .padding(.horizontal, .base)
        .padding(.vertical, 10)
        .onTapGesture {
            onNavigateToUserProfile(
                ProfileNavigationParams(
                    userId: userSocial.id,
                    username: userSocial.username
                )
            )
        }
    }
}

