//
//  FeedTabButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct FeedTabButton: View {
    let title: String
    let tab: FeedTab
    let selectedTab: FeedTab
    var underlineNS: Namespace.ID
    var onClick: (FeedTab) -> Void

    var body: some View {
        let isSelected = selectedTab == tab

        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                onClick(tab)
            }
        } label: {
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: isSelected ? .bold : .semibold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .lineLimit(1)
                    .shadow(color: .black.opacity(0.8), radius: 4, x: 2, y: 2)

                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.white)
                            .matchedGeometryEffect(id: "feedTabUnderline", in: underlineNS)
                            .frame(width: 18, height: 2.5)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                }
                .frame(height: 2.5)
            }
        }
        .buttonStyle(StaticButtonStyle())
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
