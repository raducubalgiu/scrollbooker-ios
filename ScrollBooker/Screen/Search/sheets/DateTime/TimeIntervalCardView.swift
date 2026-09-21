//
//  TimeIntervalCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct TimeIntervalCardView: View {
    let title: String
    var description: String? = nil
    var isSelected: Bool
    var fillsWidth: Bool = false
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: AppSize.xs.rawValue) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)

                if let description {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, AppSize.base.rawValue)
            .frame(minWidth: fillsWidth ? nil : 130, maxWidth: fillsWidth ? .infinity : nil, minHeight: 65)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.primarySB : Color.dividerSB, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
