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
    @Binding var selectedTab: FeedTab

    var body: some View {
        let isSelected = selectedTab == tab
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            Text(title)
                .font(.system(size: 16, weight: isSelected ? .bold : .semibold))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .lineLimit(1)
                .shadow(color: .black.opacity(0.8), radius: 4, x: 2, y: 2)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.primarySB.opacity(0.6) : Color.clear)
                .clipShape(Capsule())
                .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(StaticButtonStyle())
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
