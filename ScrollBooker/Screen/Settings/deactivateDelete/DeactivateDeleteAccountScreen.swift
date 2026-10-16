//
//  DeactivateDeleteAccountScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct DeactivateDeleteAccountScreen: View {
    var onBack: () -> Void
    var onNavigate: (Route) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "deactivateDeleteAccount"),
                onBack: onBack
            )

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                AccountActionCardView(
                    title: String(localized: "deleteAccountPermanently"),
                    description: String(localized: "deleteAccountPermanentlyDescription"),
                    titleColor: .errorSB,
                    onClick: { onNavigate(.deleteAccount) }
                )

                AccountActionCardView(
                    title: String(localized: "deactivateAccount"),
                    description: String(localized: "deactivateAccountDescription"),
                    onClick: {}
                )
            }
            .padding(.horizontal, .base)
            .padding(.top, .xl)

            Spacer()
        }
    }
}
