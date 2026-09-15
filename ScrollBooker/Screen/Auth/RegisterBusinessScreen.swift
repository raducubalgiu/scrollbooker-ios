//
//  RegisterBusinessScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterBusinessScreen: View {
    let authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        FormLayout(
            headline: String(localized: "registerBusiness"),
            subHeadline: String(localized: "registerBusinessDescription"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                Input(
                    label: String(localized: "email"),
                    text: $email,
                    placeholder: String(localized: "email"),
                    keyboardType: .emailAddress,
                )
                .textInputAutocapitalization(.never)

                Input(
                    label: String(localized: "password"),
                    text: $password,
                    placeholder: String(localized: "password"),
                    isSecure: true
                )

                MainButton(
                    title: String(localized: "register"),
                    isDisabled: authViewModel.isLoading,
                    isLoading: authViewModel.isLoading,
                    onClick: {
                        Task {
                            await authViewModel.register(
                                email: email,
                                password: password,
                                roleName: "business"
                            )
                        }
                    }
                )
                .padding(.top, .xs)
            }
            .padding(.horizontal, .xl)
        }
    }
}
