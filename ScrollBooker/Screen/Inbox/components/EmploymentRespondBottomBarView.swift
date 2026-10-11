//
//  EmploymentRespondBottomBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct EmploymentRespondBottomBarView: View {
    let isSaving: Bool
    var onDeny: () -> Void
    var onAccept: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: AppSize.s.rawValue) {
                MainButton(
                    title: String(localized: "deny"),
                    isDisabled: isSaving,
                    bgColor: .surfaceSB,
                    color: .onSurfaceSB,
                    onClick: onDeny
                )

                MainButton(
                    title: String(localized: "accept"),
                    isDisabled: isSaving,
                    onClick: onAccept
                )
            }
            .padding(.horizontal, .xl)
            .padding(.top, .base)
            .padding(.bottom, .s)
        }
        .background(Color.backgroundSB)
    }
}
