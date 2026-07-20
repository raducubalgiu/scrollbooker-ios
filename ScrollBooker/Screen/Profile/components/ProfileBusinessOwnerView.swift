//
//  ProfileBusinessOwnerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileBusinessOwnerView: View {
    var businessOwner: ProfileBusinessOwner
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    
    var body: some View {
        Button {
            onNavigateToUserProfile(
                ProfileNavigationParams(userId: businessOwner.id, username: businessOwner.username)
            )
        } label: {
            HStack {
                Image(systemName: "repeat")
                    .foregroundColor(.onBackgroundSB)
                
                AvatarView(
                    imageURL: businessOwner.avatarURL,
                    size: .s
                )
                
                Text(businessOwner.fullName)
                    .font(.headline)
                    .foregroundColor(.onBackgroundSB)
            }
        }
        .buttonStyle(.plain)
    }
}
