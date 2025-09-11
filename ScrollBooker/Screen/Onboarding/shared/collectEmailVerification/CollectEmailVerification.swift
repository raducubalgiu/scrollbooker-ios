//
//  CollectEmailVerification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectEmailVerification: View {
    @EnvironmentObject private var session: SessionManager
    
    var body: some View {
        FormLayout(
            headline: "Email Verification",
            subHeadline: "",
            buttonTitle: "Verify",
            onClick: { Task { await session.verifyEmail() } }
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectEmailVerification()
}

#Preview("Dark") {
    CollectEmailVerification()
        .preferredColorScheme(.dark)
}
