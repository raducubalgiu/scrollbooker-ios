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
            headline: "Email Verification",
            subHeadline: "",
            buttonTitle: "Verify",
            onBack: {},
            onClick: { Task { await authViewModel.verifyEmail() } },
        ) {

        }
    }
}
