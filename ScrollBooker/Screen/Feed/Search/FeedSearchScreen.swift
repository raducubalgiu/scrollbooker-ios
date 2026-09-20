//
//  FeedSearch.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedSearchScreen: View {
    @Bindable var viewModel: FeedSearchViewModel
    var onBack: () -> Void
    
    @FocusState private var isSearchFieldFocused: Bool
    
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.onBackgroundSB)
                }
                
                SearchBarView(
                    text: $viewModel.searchText,
                    placeholder: String(localized: "message_placeholder_search_users"),
                    onSubmit: { viewModel.performInstantSearch() },
                    onClear: { viewModel.clearSearchText() }
                )
                .focused($isSearchFieldFocused)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            VStack {
                switch viewModel.searchState {
                case .idle:
                    EmptyView()

                case .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                        viewModel.performInstantSearch()
                    }
                    
                case .success(let users):
                    if users.isEmpty {
                        NoDataView(
                            title: String(localized: "search"),
                            message: String(format: String(localized: "message_empty_search_users"), viewModel.searchText),
                            systemImage: "magnifyingglass"
                        )
                    } else {
                        FeedSearchSuccessView(
                            users: users,
                            onUserClick: { user in
                                onNavigateToUserProfile(
                                    ProfileNavigationParams(userId: user.id, username: user.username)
                                )
                            }
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarHidden(true)
        .onAppear {
            isSearchFieldFocused = true
        }
    }
}
