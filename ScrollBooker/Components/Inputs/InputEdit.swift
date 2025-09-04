//
//  InputEdit.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct InputEdit: View {
    @Binding var text: String
    var placeholder: String
    var label: String
    
    var isError: Bool = false
    var errorMessage: String = ""
    var isDisabled: Bool = false
    var onClear: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(label)
                .font(.headline)
                .foregroundColor(.onBackgroundSB)
            
            HStack {
                TextField(
                    placeholder,
                    text: $text
                )
                .tint(.primarySB)
                .focused($isFocused)
                .disabled(isDisabled)
                .padding(.vertical, .base)
                
                if !text.isEmpty {
                    Button {
                        onClear()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isError ? .errorSB : .gray),
                alignment: .bottom
            )
            
            if isError && !errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.errorSB)
                    Text(errorMessage).foregroundColor(.errorSB)
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

#Preview("Light") {
    @Previewable @State var text: String = ""
    
    InputEdit(
        text: $text,
        placeholder: "Some placeholder",
        label: "Label",
        onClear: {}
    )
    .padding()
    
    Spacer()
}

#Preview("Dark") {
    @Previewable @State var text: String = ""
    
    InputEdit(
        text: $text,
        placeholder: "Some placeholder",
        label: "Label",
        onClear: {}
    )
    .padding()
    .applyPreferredColorScheme(.dark)
    
    Spacer()
}

#Preview("Error") {
    @Previewable @State var text: String = ""
    
    InputEdit(
        text: $text,
        placeholder: "Some placeholder",
        label: "Label",
        isError: true,
        errorMessage: "Acest camp este obligatoriu",
        onClear: {}
    )
    .padding()
    
    Spacer()
}
