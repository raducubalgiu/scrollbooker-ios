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
    var isLoading: Bool = false
    var enabled: Bool = true
    var readOnly: Bool = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var leadingIcon: Image? = nil
    var trailingIcon: Image? = nil
    var trailingIconColor: Color = Color.onSurfaceSB
    var onCommit: (() -> Void)? = nil
    var errorMessage: String = ""
    var isSecure: Bool = false

    @FocusState private var isFocused: Bool
    @State private var isTextVisible: Bool = false

    private var isLabelFloating: Bool {
        isFocused || !text.isEmpty
    }

    private var isInteractive: Bool {
        enabled && !readOnly
    }

    private var textContentType: UITextContentType? {
        isSecure ? .password : nil
    }

    private var fieldHeight: CGFloat {
        label.isEmpty ? 40 : 52
    }

    private var labelFloatOffset: CGFloat {
        label.isEmpty ? 0 : 13
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                if !label.isEmpty {
                    Text(label)
                        .font(isLabelFloating ? .caption2 : .subheadline)
                        .foregroundColor(
                            isError
                                ? .errorSB
                                : (isFocused ? .primarySB : .onSurfaceSB)
                        )
                        .padding(.leading, leadingIcon == nil ? 16 : 44)
                        .offset(y: isLabelFloating ? -labelFloatOffset : 0)
                        .scaleEffect(isLabelFloating ? 0.92 : 1, anchor: .leading)
                }

                HStack {
                    if let leadingIcon = leadingIcon {
                        leadingIcon
                            .foregroundColor(.gray)
                    }

                    Group {
                        if isSecure && !isTextVisible {
                            SecureField(isLabelFloating ? placeholder : "", text: $text)
                                .onSubmit { onCommit?() }
                        } else {
                            TextField(isLabelFloating ? placeholder : "", text: $text)
                                .onSubmit { onCommit?() }
                                .autocapitalization(isSecure ? .none : .sentences)
                                .autocorrectionDisabled(isSecure)
                        }
                    }
                    .tint(.primary)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .disabled(!isInteractive)
                    .focused($isFocused)
                    .submitLabel(returnKeyType == .next ? .next : .done)
                    .foregroundColor(isInteractive ? .onBackgroundSB : .gray)
                    .accessibilityLabel(label.isEmpty ? placeholder : label)

                    if isLoading {
                        ProgressView()
                    } else if isSecure {
                        Button {
                            isTextVisible.toggle()
                        } label: {
                            Image(systemName: isTextVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .accessibilityLabel(isTextVisible ? "Hide password" : "Show password")
                    } else if let trailingIcon = trailingIcon {
                        trailingIcon
                            .foregroundColor(trailingIconColor)
                            .fontWeight(.heavy)
                    }
                }
                .padding(.horizontal)
                .offset(y: isLabelFloating ? labelFloatOffset * 0.5 : 0)
            }
            .frame(height: fieldHeight)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.surfaceSB)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .opacity(enabled ? 1 : 0.5)
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded {
                    guard isInteractive else { return }
                    isFocused = true
                }
            )
            .animation(.easeOut(duration: 0.18), value: isLabelFloating)

            if isError && !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.errorSB)
                    .padding(.horizontal)
            }
        }
    }

    private var borderColor: Color {
        isError ? .errorSB : .surfaceSB
    }
}
