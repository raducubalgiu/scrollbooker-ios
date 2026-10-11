//
//  RegisterBusinessScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterBusinessScreen: View {
    let authViewModel: AuthViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var identifierType: AuthIdentifierType = .email
    @State private var identifierValue: String = ""
    @State private var showCredentialScreen = false

    var body: some View {
        FormLayout(
            headline: String(localized: "auth_title_register_business"),
            subHeadline: String(localized: "auth_description_register_business"),
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
                            await authViewModel.signInWithGoogle(roleName: .business)
                        }
                    }
                )
            }
            .padding(.horizontal, .xl)
        }
        .navigationDestination(isPresented: $showCredentialScreen) {
            AuthCredentialScreen(
                authViewModel: authViewModel,
                mode: .register(roleName: "business"),
                identifierType: identifierType,
                identifierValue: identifierValue
            )
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
