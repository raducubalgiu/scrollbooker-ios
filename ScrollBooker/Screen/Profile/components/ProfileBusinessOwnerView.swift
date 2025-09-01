//
//  ProfileBusinessOwnerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileBusinessOwnerView: View {
    var businessOwner: BusinessOwner
    var onNavigateToUserProfile: () -> Void
    
    var body: some View {
        Button {
            onNavigateToUserProfile()
        } label: {
            HStack {
                Image(systemName: "repeat")
                    .foregroundColor(.onBackgroundSB)
                AvatarView(
                    imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
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

#Preview("Light") {
    ProfileBusinessOwnerView(
        businessOwner: dummyUserProfile.businessOwner!,
        onNavigateToUserProfile: {}
    )
}

#Preview("Dark") {
    ProfileBusinessOwnerView(
        businessOwner: dummyUserProfile.businessOwner!,
        onNavigateToUserProfile: {}
    )
    .preferredColorScheme(.dark)
}

