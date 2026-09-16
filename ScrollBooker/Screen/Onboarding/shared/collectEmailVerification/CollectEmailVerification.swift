//
//  CollectEmailVerification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectEmailVerification: View {
    let authViewModel: AuthViewModel

    var body: some View {
        FormLayout(
            headline: String(localized: "auth_title_email_verification"),
            subHeadline: String(localized: "auth_description_email_verification"),
            buttonTitle: String(localized: "auth_button_verify_email"),
            isDisabled: authViewModel.isLoading,
            isLoading: authViewModel.isLoading,
            onBack: {},
            onClick: { Task { await authViewModel.verifyEmail() } },
        ) {

        }
    }
}
