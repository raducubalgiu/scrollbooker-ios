//
//  AccountInfoScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct AccountInfoScreen: View {
    let viewModel: AccountInfoViewModel
    var onNavigateToPhoneVerification: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "accountInfo"),
                onBack: onBack
            )

            switch viewModel.state {
            case .idle, .loading:
                LoadingView()

            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.load() }
                }

            case .success(let info):
                VStack(alignment: .leading, spacing: 0) {
                    AccountInfoRowView(
                        title: String(localized: "phoneNumber"),
                        value: info.phone.map(Self.maskedPhone) ?? String(localized: "accountInfoNotSet"),
                        showChevron: true,
                        onClick: onNavigateToPhoneVerification
                    )

                    Divider()

                    AccountInfoRowView(
                        title: String(localized: "email"),
                        value: Self.maskedEmail(info.email),
                        showChevron: false
                    )
                }
                .padding(.horizontal, .base)
                .padding(.top, .base)

                Spacer()
            }
        }
        .onAppear {
            Task { await viewModel.load() }
        }
    }

    private static func maskedPhone(_ phone: String) -> String {
        guard phone.count > 6 else { return phone }
        let prefix = phone.prefix(3)
        let suffix = phone.suffix(3)
        let maskLength = max(phone.count - 6, 3)
        return "\(prefix)\(String(repeating: "*", count: maskLength))\(suffix)"
    }

    private static func maskedEmail(_ email: String) -> String {
        let parts = email.split(separator: "@", maxSplits: 1)
        guard parts.count == 2, let local = parts.first, let domain = parts.last, local.count > 2 else {
            return email
        }
        return "\(local.prefix(1))***\(local.suffix(1))@\(domain)"
    }
}
