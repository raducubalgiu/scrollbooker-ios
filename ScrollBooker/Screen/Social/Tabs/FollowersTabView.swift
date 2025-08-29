//
//  FollowersTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct FollowersTabView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(userFollowers) { userMini in
                    UserListItem(userMini: userMini)
                }
            }
        }
    }
}

#Preview("Light") {
    FollowersTabView()
}

#Preview("Dark") {
    FollowersTabView()
        .preferredColorScheme(.dark)
}
