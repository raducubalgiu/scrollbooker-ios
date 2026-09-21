//
//  TimeFieldButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct TimeFieldButton: View {
    let label: String
    let value: String?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                Text(label)
                    .font(.footnote)
                    .foregroundColor(.gray)

                Text(value ?? "--:--")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.onBackgroundSB)
            }
            .padding(.horizontal, AppSize.base.rawValue)
            .padding(.vertical, AppSize.m.rawValue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.dividerSB, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
