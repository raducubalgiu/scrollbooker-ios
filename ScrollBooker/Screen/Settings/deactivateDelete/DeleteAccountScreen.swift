//
//  DeleteAccountScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct DeleteAccountScreen: View {
    let viewModel: DeleteAccountViewModel
    var onBack: () -> Void

    @State private var showConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(
                title: String(localized: "deleteAccountPermanently"),
                onBack: onBack
            )

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.errorSB)
                    .padding(.top, .xl)

                Text(String(localized: "deleteAccountWarningTitle"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)

                Text(String(localized: "deleteAccountWarningDescription"))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.errorSB)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, .xs)
                }

                Spacer()

                MainButton(
                    title: String(localized: "deleteAccountPermanently"),
                    isDisabled: viewModel.isDeleting,
                    isLoading: viewModel.isDeleting,
                    bgColor: .errorSB,
                    onClick: { showConfirmation = true }
                )
            }
            .padding(.horizontal, .xl)
        }
        .background(Color.backgroundSB)
        .alert(
            String(localized: "deleteAccountConfirmTitle"),
            isPresented: $showConfirmation
        ) {
            Button(String(localized: "cancel"), role: .cancel) {}
            Button(String(localized: "deleteAccountPermanently"), role: .destructive) {
                Task { await viewModel.deleteAccount() }
            }
        } message: {
            Text(String(localized: "deleteAccountConfirmDescription"))
        }
    }
}
