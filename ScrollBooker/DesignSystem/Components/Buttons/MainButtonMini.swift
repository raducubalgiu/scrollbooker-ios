//
//  MainButtonMini.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct MainButtonMini: View {
    var title: String
    var color: Color = .onPrimarySB
    var backgroundColor = Color.primarySB
    var borderColor: Color = Color.primarySB
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(color)
        }
        .padding(.vertical, 7)
        .padding(.horizontal, .base)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor)
                .stroke(borderColor, lineWidth: 1)
        )
        .buttonStyle(.plain)
    }
}

#Preview {
    MainButtonMini(
        title: "Urmareste",
        color: Color.onPrimarySB,
        backgroundColor: Color.primarySB,
        borderColor: Color.primarySB,
        onClick: {}
    )
}
