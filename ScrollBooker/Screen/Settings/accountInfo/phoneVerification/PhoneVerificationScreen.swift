//
//  PhoneVerificationScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import SwiftUI

struct PhoneVerificationScreen: View {
    @Bindable var viewModel: PhoneVerificationViewModel
    var onVerified: (PhoneVerificationResult) -> Void
    var onBack: () -> Void

    private var isLoading: Bool {
        viewModel.step == .enterPhone ? viewModel.isSending : viewModel.isVerifying
    }

    private var isDisabled: Bool {
        viewModel.step == .enterPhone ? !viewModel.isPhoneValid : !viewModel.isCodeComplete
    }

    private var buttonTitle: String {
        viewModel.step == .enterPhone
            ? String(localized: "phoneVerificationSendCode")
            : String(localized: "phoneVerificationVerify")
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "phoneVerificationTitle"),
            subHeadline: viewModel.step == .enterPhone
                ? String(localized: "phoneVerificationPhoneDescription")
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
            Text(PhoneVerificationViewModel.countryCode)
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
        } else if await viewModel.verifyCode(), let result = viewModel.verifiedResult {
            onVerified(result)
        }
    }
}
