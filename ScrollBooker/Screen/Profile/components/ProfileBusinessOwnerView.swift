//
//  ProfileBusinessOwnerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileBusinessOwnerView: View {
    var businessOwner: ProfileBusinessOwner
    var onNavigateToUserProfile: (Int, String) -> Void
    
    var body: some View {
        Button {
            onNavigateToUserProfile(businessOwner.id, businessOwner.fullName)
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
