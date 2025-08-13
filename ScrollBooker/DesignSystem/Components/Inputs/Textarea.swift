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
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(label)
                .font(.headline)
                .foregroundColor(.onBackgroundSB)
            
            TextEditor(text: $text)
                .focused($isFocused)
                .frame(minHeight: CGFloat(height), maxHeight: CGFloat(height))
                .scrollContentBackground(.hidden)
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.vertical, .s)
                    }
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isError ? .errorSB : .gray),
                    alignment: .bottom
                )
                .tint(.primarySB)
            
            if isError && !errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.errorSB)
                    Text(errorMessage).foregroundColor(.errorSB)
                }
            }
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
