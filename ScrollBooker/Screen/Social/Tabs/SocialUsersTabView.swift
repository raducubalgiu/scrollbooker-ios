//
//  SocialUsersTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct SocialUsersTabView: View {
    let state: SocialTabState<UserSocial>
    
    let noDataTitle: String
    let noDataMessage: String
    
    var onRefresh: () async -> Void
    var onLoadMore: (UserSocial) -> Void
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    var onFollow: (UserSocial) -> Void
    
    var body: some View {
        VStack {
            switch state {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await onRefresh() }
                    }
                    
                case .success(let users, let hasMore, let isPaging):
                    if users.isEmpty {
                        NoDataView(
                            title: noDataTitle,
                            message: noDataMessage,
                            systemImage: "person.2"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(users, id: \.id) { userSocial in
                                    UserListItem(
                                        userSocial: userSocial,
                                        onNavigateToUserProfile: onNavigateToUserProfile,
                                        onFollow: onFollow
                                    )
                                        .onAppear {
                                            onLoadMore(userSocial)
                                        }
                                }
                                
                                if hasMore || isPaging {
                                    ProgressView()
                                        .frame(height: 60)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .refreshable {
                            await onRefresh()
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
