//
//  FeedSearch.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct FeedSearchScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Caută", text: $searchText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($isSearchFieldFocused)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.surfaceSB)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Divider()
            
            // Conținutul ecranului
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            isSearchFieldFocused = true
        }
    }
}

#Preview("Light") {
    FeedSearchScreen()
}

#Preview("Dark") {
    FeedSearchScreen()
    .preferredColorScheme(.dark)
}
