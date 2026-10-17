//
//  CollectBusinessPublicPhoneScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import SwiftUI

struct CollectBusinessPublicPhoneScreen: View {
    @Bindable var viewModel: CollectBusinessPublicPhoneViewModel
    let onBack: () -> Void

    private var isLoading: Bool {
        viewModel.step == .enterPhone ? viewModel.isSending : viewModel.isSaving
    }

    private var isDisabled: Bool {
        viewModel.step == .enterPhone ? !viewModel.isPhoneValid : !viewModel.isCodeComplete
    }

    private var buttonTitle: String {
        viewModel.step == .enterPhone
            ? String(localized: "phoneVerificationSendCode")
            : String(localized: "nextStep")
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_public_phone_title"),
            subHeadline: viewModel.step == .enterPhone
                ? String(localized: "onboarding_public_phone_description")
                : String(format: String(localized: "phoneVerificationCodeDescription"), viewModel.fullPhone),
            enableBack: true,
            buttonTitle: buttonTitle,
            isDisabled: isDisabled || isLoading,
            isLoading: isLoading,
            onBack: viewModel.step == .enterPhone ? onBack : { viewModel.backToPhoneStep() },
            onClick: { Task { await submit() } }
        ) {
            VStack(spacing: AppSize.base.rawValue) {
                if viewModel.step == .enterPhone {
                    phoneInput
                } else {
                    codeInput
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.errorSB)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, .xl)
        }
    }

    private var phoneInput: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Text(CollectBusinessPublicPhoneViewModel.countryCode)
                .font(.subheadline.bold())
                .foregroundColor(.onBackgroundSB)
                .padding(.horizontal, AppSize.base.rawValue)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.surfaceSB)
                )

            Input(
                text: $viewModel.localNumber,
                placeholder: String(localized: "phoneVerificationPlaceholder"),
                keyboardType: .numberPad
            )
            .onChange(of: viewModel.localNumber) { _, newValue in
                let filtered = String(newValue.filter(\.isNumber).prefix(10))
                if filtered != newValue { viewModel.localNumber = filtered }
            }
        }
    }

    private var codeInput: some View {
        Input(
            text: $viewModel.code,
            placeholder: String(localized: "phoneVerificationCodePlaceholder"),
            keyboardType: .numberPad
        )
        .onChange(of: viewModel.code) { _, newValue in
            let filtered = String(newValue.filter(\.isNumber).prefix(6))
            if filtered != newValue { viewModel.code = filtered }
        }
    }

    private func submit() async {
        if viewModel.step == .enterPhone {
            await viewModel.sendCode()
        } else {
            await viewModel.collectBusinessPublicPhone()
        }
    }
}
