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
            headline: "Inregistrare Business",
            subHeadline: "Creaza un cont pentru a-ti inregistra afacerea si a incepe procesul de configurare",
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
                title: "Inregistrare",
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
