//
//  SearchBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var placeholder: String = String(localized: "search")
    var onSubmit: (() -> Void)? = nil
    var onClear: (() -> Void)? = nil
    
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isSearchFieldFocused)
                .submitLabel(.search)
                .onSubmit {
                    onSubmit?()
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.surfaceSB)
        .cornerRadius(8)
        .onAppear {
            isSearchFieldFocused = true
        }
    }
}
