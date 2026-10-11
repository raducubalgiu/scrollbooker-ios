//
//  RegisterScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterScreen: View {
    let authViewModel: AuthViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var identifierType: AuthIdentifierType = .email
    @State private var identifierValue: String = ""
    @State private var showCredentialScreen = false
    @State private var showRegisterBusiness = false

    var body: some View {
        FormLayout(
            headline: String(localized: "register"),
            subHeadline: String(localized: "auth_description_register"),
            enableBottomButton: false,
            enableBack: true,
            onBack: { dismiss() }
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                IdentifierPickerView(
                    availableTypes: [.email, .phone],
                    identifierType: $identifierType,
                    identifierValue: $identifierValue
                )

                MainButton(
                    title: String(localized: "auth_continue_button"),
                    isDisabled: identifierValue.isEmpty,
                    isLoading: false,
                    onClick: { showCredentialScreen = true }
                )
                .padding(.top, .xs)

                SocialSignInSectionView(
                    isDisabled: authViewModel.isLoading,
                    onGoogleClick: {
                        Task {
                            await authViewModel.signInWithGoogle(roleName: .client)
                        }
                    }
                )

                RegisterBusinessCTOView(onClick: { showRegisterBusiness = true })
                    .padding(.top, .base)

                Spacer()

                HStack {
                    Text(String(localized: "auth_description_already_have_account"))
                        .font(.subheadline)

                    Button(String(localized: "login")) {
                        dismiss()
                    }
                    .foregroundColor(.primarySB)
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, .base)
            }
            .padding(.horizontal, .xl)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationDestination(isPresented: $showCredentialScreen) {
            AuthCredentialScreen(
                authViewModel: authViewModel,
                mode: .register(roleName: "client"),
                identifierType: identifierType,
                identifierValue: identifierValue
            )
            .toolbar(.hidden, for: .navigationBar)
        }
        .navigationDestination(isPresented: $showRegisterBusiness) {
            BusinessRegisterIntroScreen(authViewModel: authViewModel)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
