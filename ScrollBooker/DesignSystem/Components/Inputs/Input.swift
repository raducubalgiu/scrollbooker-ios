//
//  Input.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct Input: View {
    var label: String = ""
    @Binding var text: String
    var placeholder: String = ""
    var isError: Bool = false
    var enabled: Bool = true
    var readOnly: Bool = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var leadingIcon: Image? = nil
    var trailingIcon: Image? = nil
    var onCommit: (() -> Void)? = nil
    var errorMessage: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if !label.isEmpty && isFocused {
                Text(label)
                    .font(.headline)
                    .foregroundColor(isFocused ? .primarySB : .onSurfaceSB)
                    .padding(.horizontal)
            }
            
            HStack {
                if let leadingIcon = leadingIcon {
                    leadingIcon.foregroundColor(.gray)
                }
                
                TextField(
                    isFocused ? "" : placeholder,
                    text: $text,
                    onCommit: { onCommit?() }
                )
                .tint(.primary)
                .keyboardType(keyboardType)
                .disabled(!enabled || readOnly)
                .focused($isFocused)
                .submitLabel(returnKeyType == .next ? .next : .done)
                .foregroundColor(readOnly ? .gray : .onBackgroundSB)
                
                if let trailingIcon = trailingIcon {
                    trailingIcon.foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
        .frame(minHeight: 40)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.surfaceSB)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            guard enabled && !readOnly else { return }
            isFocused = true
        }
        
        if isError && !errorMessage.isEmpty {
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.errorSB)
        }
    }
    
    private var borderColor: Color {
        isError ? .errorSB : .surfaceSB
    }
}

#Preview("Light") {
    @Previewable @State var text: String = "radu_balgiu"
    
    Input(
        label: "Email",
        text: $text,
        isError: false
    )
    .padding()
    
    Spacer()
}
