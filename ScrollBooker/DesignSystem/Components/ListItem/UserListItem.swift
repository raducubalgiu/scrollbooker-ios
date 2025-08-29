//
//  UserListItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct UserListItem: View {
    var userMini: UserMini
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                AvatarView(
                    imageURL: userMini.avatarURL,
                    size: .l
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(userMini.fullName)
                        .font(.headline)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("@\(userMini.username)")
                        .font(.subheadline)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text(userMini.isFollow ? "following" : "follow")
                        .font(.subheadline.bold())
                        .foregroundColor(userMini.isFollow ? .onBackgroundSB : .onPrimarySB)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, .base)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(userMini.isFollow ? Color.backgroundSB : Color.primarySB)
                        .stroke(userMini.isFollow ? .divider : Color.primarySB, lineWidth: 1)
                )
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .padding(.horizontal, .base)
        .padding(.vertical, 10)
    }
}

#Preview("Light") {
    UserListItem(
        userMini: userFollowers[0]
    )
}

#Preview("Dark") {
    UserListItem(
        userMini: userFollowers[0]
    )
        .preferredColorScheme(.dark)
}

