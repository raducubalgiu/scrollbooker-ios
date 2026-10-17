//
//  BookingContactBottomBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import SwiftUI

struct BookingContactBottomBarView: View {
    var onWriteOnWhatsApp: () -> Void = {}
    var onCall: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.dividerSB)
                .frame(height: 0.55)

            HStack(alignment: .center, spacing: AppSize.m.rawValue) {
                MainButtonOutlined(
                    title: String(localized: "writeOnWhatsApp"),
                    size: .medium,
                    fullWidth: true,
                    onClick: onWriteOnWhatsApp
                )
                .frame(maxWidth: .infinity)

                MainButton(
                    title: String(localized: "call"),
                    size: .medium,
                    onClick: onCall
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(Color(uiColor: .systemBackground))
        }
    }
}
