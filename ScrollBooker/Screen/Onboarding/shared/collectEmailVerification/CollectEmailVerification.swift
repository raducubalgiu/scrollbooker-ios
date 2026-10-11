//
//  CollectEmailVerification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

private let resendCooldownSeconds = 60

struct CollectEmailVerification: View {
    let authViewModel: AuthViewModel

    @State private var code: String = ""
    @State private var cooldown: Int = resendCooldownSeconds
    @State private var countdownTask: Task<Void, Never>?

    private var isCodeComplete: Bool {
        code.count == 6
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_email_verification_title"),
            subHeadline: String(localized: "onboarding_email_verification_description"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(spacing: AppSize.base.rawValue) {
                Input(
                    text: $code,
                    placeholder: String(localized: "onboarding_email_verification_code_placeholder"),
                    keyboardType: .numberPad
                )
                .onChange(of: code) { _, newValue in
                    let filtered = String(newValue.filter(\.isNumber).prefix(6))
                    if filtered != newValue { code = filtered }
                }

                MainButton(
                    title: String(localized: "onboarding_email_verification_verify"),
                    isDisabled: authViewModel.isLoading || authViewModel.isResendingVerificationEmail || !isCodeComplete,
                    isLoading: authViewModel.isLoading,
                    onClick: { Task { await authViewModel.verifyEmail(code: code) } }
                )

                VStack(spacing: AppSize.xs.rawValue) {
                    Text(String(localized: "onboarding_email_verification_no_email"))
                        .foregroundColor(.gray)

                    Button {
                        Task { await resend() }
                    } label: {
                        Text(
                            cooldown > 0
                                ? String(format: String(localized: "onboarding_email_verification_resend_cooldown"), cooldown)
                                : String(localized: "onboarding_email_verification_resend")
                        )
                        .fontWeight(.semibold)
                    }
                    .disabled(cooldown > 0 || authViewModel.isLoading || authViewModel.isResendingVerificationEmail)
                }
                .padding(.top, .base)
            }
            .padding(.horizontal, .xl)
        }
        .onAppear { startCountdown() }
        .onDisappear { countdownTask?.cancel() }
    }

    private func resend() async {
        await authViewModel.resendVerificationEmail()
        startCountdown()
    }

    private func startCountdown() {
        countdownTask?.cancel()
        cooldown = resendCooldownSeconds

        countdownTask = Task {
            while cooldown > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                cooldown -= 1
            }
        }
    }
}
