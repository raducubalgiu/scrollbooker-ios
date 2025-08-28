//
//  RegisterBusinessScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterBusinessScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        FormLayout(
            headline: String(localized: "registerBusiness"),
            subHeadline: String(localized: "registerBusinessDescription"),
            enableBottomButton: false,
        ) {
            Input(
                label: "Email",
                text: $email,
                placeholder: "Email",
                keyboardType: .emailAddress,
            )
            
            Input(
                label: "Parola",
                text: $password,
                placeholder: "Parola",
                keyboardType: .emailAddress,
            )
            
            MainButton(
                title: String(localized: "register"),
                onClick: {  }
            )
        }
    }
}

#Preview("Light") {
    RegisterBusinessScreen()
}

#Preview("Dark") {
    RegisterBusinessScreen()
        .preferredColorScheme(.dark)
}
