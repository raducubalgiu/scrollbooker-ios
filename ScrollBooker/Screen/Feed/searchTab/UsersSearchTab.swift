//
//  UsersSearchTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct UsersSearchTab: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(dummySearchedUsers) { userMini in
                    UserListItem(userMini: userMini)
                }
            }
        }
    }
}

#Preview("Light") {
    UsersSearchTab()
}

#Preview("Dark") {
    UsersSearchTab()
        .preferredColorScheme(.dark)
}
