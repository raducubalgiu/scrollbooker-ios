//
//  CategoryTagView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct CategoryTagView: View {
    let label: String
    let isSelected: Bool
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: AppSize.xs.rawValue) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .transition(.scale.combined(with: .opacity))
                }

                Text(label)
                    .font(.footnote)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .onPrimarySB : .onBackgroundSB)
            .padding(.horizontal, AppSize.m.rawValue)
            .padding(.vertical, AppSize.s.rawValue)
            .background(isSelected ? Color.primarySB : Color.surfaceSB)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.primarySB : Color.dividerSB, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
