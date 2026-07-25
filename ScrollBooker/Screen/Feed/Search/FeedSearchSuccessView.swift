//
//  FeedSearchSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct FeedSearchSuccessView: View {
    var users: [SearchUser]
    var onUserClick: (SearchUser) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(users) { user in
                    SearchUserView(
                        user: user,
                        onUserClick: onUserClick
                    )
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}
