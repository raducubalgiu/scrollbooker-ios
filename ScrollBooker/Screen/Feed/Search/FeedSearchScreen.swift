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
                    placeholder: String(localized: "search"),
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
                    VStack {
                        Spacer()
                        Text(String(localized: "searchUsersInApp"))
                            .font(.body)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                case .loading:
                    LoadingView()
                    
                case .empty:
                    NoDataView(
                        title: String(localized: "search"),
                        message: "Nu s-a găsit niciun rezultat pentru \"\(viewModel.searchText)\"",
                        systemImage: "magnifyingglass"
                    )
                    
                case .success(let users):
                    FeedSearchSuccessView(
                        users: users,
                        onNavigateToUserProfile: onNavigateToUserProfile
                    )
                    
                case .error(let message):
                    ErrorView(message: message) {
                        viewModel.performInstantSearch()
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
