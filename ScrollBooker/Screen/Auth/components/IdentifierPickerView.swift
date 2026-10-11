//
//  IdentifierPickerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct IdentifierPickerView: View {
    let availableTypes: [AuthIdentifierType]
    @Binding var identifierType: AuthIdentifierType
    @Binding var identifierValue: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 0) {
            Menu {
                ForEach(availableTypes, id: \.self) { type in
                    Button(type.label) {
                        identifierType = type
                        identifierValue = ""
                    }
                }
            } label: {
                HStack(spacing: AppSize.xs.rawValue) {
                    Text(identifierType.label)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)

                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.onBackgroundSB)
            }
            .padding(.horizontal, AppSize.s.rawValue)

            Divider()
                .frame(height: 22)

            TextField(identifierType.placeholder, text: $identifierValue)
                .keyboardType(identifierType.keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundColor(.onBackgroundSB)
                .focused($isFocused)
                .padding(.horizontal, AppSize.s.rawValue)
        }
        .frame(height: 52)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.surfaceSB)
        )
        .animation(.easeOut(duration: 0.18), value: isFocused)
    }
}
