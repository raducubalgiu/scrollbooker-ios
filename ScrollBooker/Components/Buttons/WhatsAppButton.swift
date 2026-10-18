//
//  WhatsAppButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

import SwiftUI

/// Visual test: WhatsApp's brand green + a stand-in icon (SF Symbols has no actual WhatsApp
/// glyph — `phone.bubble.left.fill` is the closest shape, not the real logo). If this doesn't
/// read well in context, the call sites fall back to the app's own `MainButton` style instead.
struct WhatsAppButton: View {
    var title: String = String(localized: "writeOnWhatsApp")
    var size: AppButtonSize = .medium
    var onClick: () -> Void

    private static let whatsAppGreen = Color(red: 0.145, green: 0.827, blue: 0.4)

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: AppSize.xs.rawValue) {
                Image(systemName: "phone.bubble.left.fill")
                Text(title)
                    .font(size.font)
            }
            .frame(maxWidth: .infinity, minHeight: size.minHeight)
            .contentShape(Rectangle())
        }
        .fontWeight(.semibold)
        .padding(.horizontal, size.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Self.whatsAppGreen)
        )
        .foregroundColor(.white)
        .buttonStyle(.plain)
    }
}
