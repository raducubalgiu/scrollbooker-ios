//
//  Textarea.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct Textarea: View {
    @Binding var text: String
    
    var label: String
    var placeholder: String
    var height: Int = 100
    
    var isError: Bool = false
    var errorMessage: String = ""
    var isDisabled: Bool = false
    var maxLength: Int = 500
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if !label.isEmpty {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.onBackgroundSB)
            }
            
            TextEditor(text: $text)
                .focused($isFocused)
                .textEditorStyle(.plain)
                .frame(minHeight: CGFloat(height), maxHeight: CGFloat(height))
                .scrollContentBackground(.hidden)
                .disabled(isDisabled)
                .onChange(of: text) { _, newValue in
                    if newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                            .allowsHitTesting(false)
                    }
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isError ? .errorSB : (isFocused ? .primarySB : .gray)),
                    alignment: .bottom
                )
                .tint(.primarySB)
            
            HStack(alignment: .top) {
                if isError && !errorMessage.isEmpty {
                    HStack(spacing: 5) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.errorSB)
                        Text(errorMessage)
                            .foregroundColor(.errorSB)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Text("\(text.count) / \(maxLength)")
                    .font(.caption)
                    .foregroundColor(text.count >= maxLength ? .errorSB : .gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !isDisabled else { return }
            isFocused = true
        }
    }
}

#Preview("Light") {
    @Previewable @State var text: String = ""
    
    Textarea(
        text: $text,
        label: "Placeholder",
        placeholder: "Adauga o descriere"
    )
    .padding()
    
    Spacer()
}

#Preview("Dark") {
    @Previewable @State var text: String = ""
    
    Textarea(
        text: $text,
        label: "Placeholder",
        placeholder: "Adauga o descriere"
    )
    .preferredColorScheme(.dark)
    .padding()
    
    Spacer()
}

#Preview("Error") {
    @Previewable @State var text: String = ""
    
    Textarea(
        text: $text,
        label: "Placeholder",
        placeholder: "Adauga o descriere",
        isError: true,
        errorMessage: "Acest camp este obligatoriu"
    )
    .padding()
    
    Spacer()
}
