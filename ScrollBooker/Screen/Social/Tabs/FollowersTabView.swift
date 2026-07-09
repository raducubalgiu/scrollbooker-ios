//
//  FollowersTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

struct FollowersTabView: View {
    let users: [UserSocial]
    let isLoading: Bool
    
    var onLoadMore: (UserSocial) -> Void
    
    var body: some View {
        Group {
            if users.isEmpty && !isLoading {
                Color.clear
            } else {
                ZStack(alignment: .center) {
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(users, id: \.id) { userSocial in
                                UserListItem(userSocial: userSocial)
                                    .onAppear {
                                        onLoadMore(userSocial)
                                    }
                            }
                            
                            if isLoading && !users.isEmpty {
                                Color.clear
                                    .frame(height: 50)
                            }
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview("Light") {
//    FollowersTabView()
//}
//
//#Preview("Dark") {
//    FollowersTabView()
//        .preferredColorScheme(.dark)
//}
