//
//  LoginScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct LoginScreen: View {
    let authViewModel: AuthViewModel

    @State private var identifierType: AuthIdentifierType = .email
    @State private var identifierValue: String = ""
    @State private var showCredentialScreen = false
    @State private var showRegisterBusiness = false

    var body: some View {
        FormLayout(
            headline: String(localized: "login"),
            subHeadline: String(localized: "auth_description_login"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                IdentifierPickerView(
                    availableTypes: [.email, .username, .phone],
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
                    Text(String(localized: "auth_description_dont_have_account"))
                        .font(.subheadline)

                    NavigationLink(String(localized: "register")) {
                        RegisterScreen(authViewModel: authViewModel)
                            .toolbar(.hidden, for: .navigationBar)
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
                mode: .login,
                identifierType: identifierType,
                identifierValue: identifierValue
            )
            .toolbar(.hidden, for: .navigationBar)
        }
        .navigationDestination(isPresented: $showRegisterBusiness) {
            RegisterBusinessScreen(authViewModel: authViewModel)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
