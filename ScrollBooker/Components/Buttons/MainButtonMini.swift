//
//  MainButtonMini.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct MainButtonMiniStyle {
    let color: Color
    let backgroundColor: Color
    let borderColor: Color

    static let filled = MainButtonMiniStyle(
        color: .onPrimarySB,
        backgroundColor: .primarySB,
        borderColor: .primarySB
    )

    static let outlined = MainButtonMiniStyle(
        color: .onBackgroundSB,
        backgroundColor: .clear,
        borderColor: .divider
    )
}

struct MainButtonMini: View {
    var title: String
    var color: Color
    var backgroundColor: Color
    var borderColor: Color
    var onClick: () -> Void

    init(
        title: String,
        color: Color = .onPrimarySB,
        backgroundColor: Color = .primarySB,
        borderColor: Color = .primarySB,
        onClick: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.onClick = onClick
    }

    init(
        title: String,
        style: MainButtonMiniStyle,
        onClick: @escaping () -> Void
    ) {
        self.title = title
        self.color = style.color
        self.backgroundColor = style.backgroundColor
        self.borderColor = style.borderColor
        self.onClick = onClick
    }

    var body: some View {
        Button {
            onClick()
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(color)
                .lineLimit(1)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .frame(minHeight: 28)
        .background(
            RoundedRectangle(cornerRadius: 50)
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
