//
//  SearchUserView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct SearchUserView: View {
    var user: SearchUser
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    
    private var avatarURL: URL? {
        guard let avatarString = user.avatar, !avatarString.isEmpty else { return nil }
        return URL(string: avatarString)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if(user.isBusinessOrEmployee) {
                AvatarWithRatingView(
                    url: avatarURL,
                    rating: user.ratingsAverage,
                    size: .l
                )
            } else {
                AvatarView(
                    imageURL: avatarURL,
                    size: .l,
                )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.fullName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text("@\(user.username)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.horizontal, .base)
        .padding(.vertical, 10)
        .onTapGesture {
            onNavigateToUserProfile(
                ProfileNavigationParams(
                    userId: user.id,
                    username: user.username
                )
            )
        }
    }
}
