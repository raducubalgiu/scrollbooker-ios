//
//  EmploymentEmployeesListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct EmploymentEmployeesListView: View {
    let users: [SearchUser]
    
    @Binding var selectedUser: SearchUser?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(users) { user in
                    Button(action: {
                        if selectedUser?.id == user.id {
                            selectedUser = nil
                        } else {
                            selectedUser = user
                        }
                    }) {
                        HStack(spacing: 12) {
                            AvatarView(
                                imageURL: user.avatarURL,
                                size: .m
                            )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.fullName)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                

                                Text("@\(user.username)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                if selectedUser?.id == user.id {
                                    Circle()
                                        .fill(Color.primarySB)
                                        .frame(width: 25, height: 25)
                                    
                                    Circle()
                                        .fill(Color.backgroundSB)
                                        .frame(width: 10, height: 10)
                                } else {
                                    Circle()
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                        .frame(width: 25, height: 25)
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                        .padding(.leading, 64)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}
