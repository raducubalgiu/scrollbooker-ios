//
//  FollowingsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct FollowingsTabView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(userFollowings) { userMini in
                    UserListItem(userMini: userMini)
                }
            }
        }
    }
}

#Preview("Light") {
    FollowingsTabView()
}

#Preview("Dark") {
    FollowingsTabView()
        .preferredColorScheme(.dark)
}
