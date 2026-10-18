//
//  PublicPhoneScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import SwiftUI

struct PublicPhoneScreen: View {
    let viewModel: PublicPhoneViewModel
    var onEditPersonalNumber: () -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "publicPhoneTitle"),
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
                PublicPhoneSuccessView(
                    info: info,
                    isEmployee: viewModel.isEmployee,
                    isSwitching: viewModel.isSwitchingToBusinessNumber,
                    switchError: viewModel.switchError,
                    isUpdatingContactPreference: viewModel.isUpdatingContactPreference,
                    contactPreferenceError: viewModel.contactPreferenceError,
                    onUseBusinessNumber: { Task { await viewModel.useBusinessNumber() } },
                    onEditPersonalNumber: onEditPersonalNumber,
                    onToggleWhatsapp: { accepts in Task { await viewModel.setAcceptsWhatsapp(accepts) } },
                    onToggleCalls: { accepts in Task { await viewModel.setAcceptsCalls(accepts) } }
                )
            }
        }
        .onAppear {
            Task { await viewModel.load() }
        }
    }
}
