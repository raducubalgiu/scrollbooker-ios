//
//  SelectionChipButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct SelectionChipButton: View {
    let icon: String
    let title: String
    var isActive: Bool
    var isEnabled: Bool = true
    var onTap: () -> Void
    var onClear: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSize.s.rawValue) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.onBackgroundSB)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isEnabled ? .onBackgroundSB : .gray)
                    .lineLimit(1)

                Spacer(minLength: 0)

                if isActive {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.onBackgroundSB)
                        .onTapGesture {
                            onClear()
                        }
                } else if isEnabled {
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.onBackgroundSB)
                }
            }
            .padding(.horizontal, AppSize.base.rawValue)
            .padding(.vertical, AppSize.m.rawValue)
            .frame(maxWidth: .infinity)
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.dividerSB, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
