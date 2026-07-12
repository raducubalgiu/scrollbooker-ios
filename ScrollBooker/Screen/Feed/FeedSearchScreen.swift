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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: {
                    onBack()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                SearchBarView(
                    text: $viewModel.searchText,
                    placeholder: String(localized: "search"),
                    onSubmit: { viewModel.performInstantSearch() },
                    onClear: {}
                )
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            VStack {
                switch viewModel.searchState {
                    case .idle:
                        VStack {
                            Spacer()
                            Text("Caută utilizatori în aplicație")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                    case .loading:
                        LoadingView()
                        
                    case .empty:
                        NoDataView(
                            title: "Cauta",
                            message: "Nu s-a găsit niciun rezultat pentru \"\(viewModel.searchText)\""
                        )
                        
                    case .success(let users):
                        List(users) { user in
                            HStack {
                                Text(user.fullName)
                                    .font(.body)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .listStyle(.plain)
                        .scrollDismissesKeyboard(.immediately)
                        
                    case .error(let message):
                        ErrorView(
                            message: message,
                            retryAction: { viewModel.performInstantSearch() }
                        )
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
