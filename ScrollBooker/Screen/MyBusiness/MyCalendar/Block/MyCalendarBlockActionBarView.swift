//
//  MyCalendarBlockActionBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarBlockActionBarView: View {
    let isEnabled: Bool
    var onCancel: () -> Void
    var onBlockConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: AppSize.s.rawValue) {
                MainButton(
                    title: String(localized: "cancel"),
                    bgColor: .surfaceSB,
                    color: .onBackgroundSB,
                    onClick: onCancel
                )

                MainButton(
                    title: String(localized: "block"),
                    isDisabled: !isEnabled,
                    bgColor: .errorSB.opacity(0.2),
                    color: .errorSB,
                    onClick: onBlockConfirm
                )
            }
            .padding(.base)
        }
        .background(Color.backgroundSB)
        .transition(.opacity)
    }
}
