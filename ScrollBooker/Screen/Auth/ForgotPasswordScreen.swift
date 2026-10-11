//
//  ForgotPasswordScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""

    var body: some View {
        FormLayout(
            headline: String(localized: "auth_forgot_password_title"),
            subHeadline: String(localized: "auth_forgot_password_description"),
            enableBack: true,
            buttonTitle: String(localized: "auth_forgot_password_submit"),
            onBack: { dismiss() }
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                Input(
                    label: String(localized: "email"),
                    text: $email,
                    placeholder: String(localized: "email"),
                    keyboardType: .emailAddress
                )
                .textInputAutocapitalization(.never)
            }
            .padding(.horizontal, .xl)
        }
    }
}
