//
//  AuthCredentialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

enum AuthFlowMode {
    case login
    case register(roleName: String)
}

struct AuthCredentialScreen: View {
    let authViewModel: AuthViewModel
    let mode: AuthFlowMode
    let identifierType: AuthIdentifierType
    let identifierValue: String

    @Environment(\.dismiss) private var dismiss

    @State private var password: String = ""
    @State private var smsCode: String = ""

    private var isPhoneFlow: Bool {
        identifierType == .phone
    }

    private var headline: String {
        isPhoneFlow ? String(localized: "auth_phone_code_title") : String(localized: "auth_password_title")
    }

    private var isLoginFlow: Bool {
        if case .login = mode { return true }
        return false
    }

    private var subHeadline: String {
        if isPhoneFlow {
            return String(localized: "auth_phone_code_description")
        }
        return isLoginFlow
            ? String(localized: "auth_password_login_description")
            : String(localized: "auth_password_register_description")
    }

    private var buttonTitle: String {
        isLoginFlow ? String(localized: "auth_continue_button") : String(localized: "register")
    }

    var body: some View {
        FormLayout(
            headline: headline,
            subHeadline: subHeadline,
            enableBottomButton: false,
            enableBack: true,
            onBack: { dismiss() }
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                if isPhoneFlow {
                    Input(
                        text: $smsCode,
                        placeholder: String(localized: "auth_phone_code_placeholder"),
                        keyboardType: .numberPad
                    )
                    .onChange(of: smsCode) { _, newValue in
                        let filtered = String(newValue.filter(\.isNumber).prefix(6))
                        if filtered != newValue { smsCode = filtered }
                    }
                } else {
                    Input(
                        label: String(localized: "password"),
                        text: $password,
                        placeholder: String(localized: "password"),
                        isSecure: true
                    )

                    if isLoginFlow {
                        HStack {
                            Spacer()

                            NavigationLink(String(localized: "auth_forgot_password_cta")) {
                                ForgotPasswordScreen()
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.primarySB)
                        }
                        .padding(.top, .xxs)
                    }
                }

                MainButton(
                    title: buttonTitle,
                    isDisabled: authViewModel.isLoading,
                    isLoading: authViewModel.isLoading,
                    onClick: {
                        guard !isPhoneFlow else { return }

                        Task {
                            switch mode {
                            case .login:
                                await authViewModel.login(identifier: identifierValue, password: password)
                            case .register(let roleName):
                                await authViewModel.register(email: identifierValue, password: password, roleName: roleName)
                            }
                        }
                    }
                )
                .padding(.top, .xs)
            }
            .padding(.horizontal, .xl)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
