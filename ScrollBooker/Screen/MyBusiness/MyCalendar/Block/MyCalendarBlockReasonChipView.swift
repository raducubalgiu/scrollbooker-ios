//
//  MyCalendarBlockReasonChipView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarBlockReasonChipView: View {
    let title: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .primarySB : .onBackgroundSB)
                .padding(.horizontal, .m)
                .padding(.vertical, .s)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.primarySB.opacity(0.2) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.dividerSB, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
