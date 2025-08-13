//
//  CollectEmailVerification.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectEmailVerification: View {
    var body: some View {
        FormLayout(
            headline: "Email Verification",
            subHeadline: "",
            buttonTitle: "Verify"
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
