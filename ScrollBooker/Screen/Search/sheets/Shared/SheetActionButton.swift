//
//  SheetActionButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct SheetActionButton: View {
    enum Style {
        case filled
        case outlined
    }

    var title: String
    var style: Style = .filled
    var isDisabled: Bool = false
    var onClick: () -> Void

    private let height: CGFloat = 50

    var body: some View {
        Button(action: onClick) {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, minHeight: height)
        }
        .foregroundColor(foregroundColor)
        .background(background)
        .disabled(isDisabled)
        .buttonStyle(.plain)
    }

    private var foregroundColor: Color {
        switch style {
            case .filled: return isDisabled ? .gray : .onPrimarySB
            case .outlined: return isDisabled ? .gray : .onBackgroundSB
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
            case .filled:
                Capsule().fill(isDisabled ? Color.surfaceSB : Color.primarySB)
            case .outlined:
                Capsule().strokeBorder(Color.dividerSB, lineWidth: 1)
        }
    }
}
