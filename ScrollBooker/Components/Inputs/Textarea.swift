//
//  Textarea.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct Textarea: View {
    @Binding var text: String
    var placeholder: String
    var label: String
    
    var isError: Bool = false
    var errorMessage: String = ""
    var isDisabled: Bool = false
    var maxLength: Int? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.headline)
                .foregroundColor(.onBackgroundSB)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                
                TextEditor(text: $text)
                    .tint(.primarySB)
                    .focused($isFocused)
                    .disabled(isDisabled)
                    .frame(height: 120)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .onChange(of: text) { oldValue, newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isError ? .errorSB : (isFocused ? .primarySB : .gray.opacity(0.5))),
                alignment: .bottom
            )
            
            HStack {
                if isError && !errorMessage.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.errorSB)
                        Text(errorMessage)
                            .foregroundColor(.errorSB)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                if let max = maxLength {
                    Text("\(text.count)/\(max)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !isDisabled else { return }
            isFocused = true
        }
    }
}
