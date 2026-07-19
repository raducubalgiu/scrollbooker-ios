//
//  UserListItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct UserListItem: View {
    var userSocial: UserSocial
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                AvatarView(
                    imageURL: URL(string: userSocial.avatar ?? ""),
                    size: .l
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(userSocial.fullName)
                        .font(.headline)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("@\(userSocial.username)")
                        .font(.subheadline)
                        .foregroundColor(.onBackgroundSB)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Button {
                    
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
    }
}

