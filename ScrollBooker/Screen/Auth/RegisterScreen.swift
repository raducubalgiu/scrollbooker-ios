//
//  RegisterScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        FormLayout(
            headline: "Inregistrare",
            subHeadline: "Please register to continue",
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
            
            HStack {
                Text("Ai deja un cont?")
                Button("Login") {
                    
                }
                .foregroundColor(.primarySB)
                .fontWeight(.bold)
            }
            
            VStack {
                Spacer()
                
                Divider()
                
                Text("Ai un business care primeste programari?")
                    .padding(.vertical)
                
                MainButtonOutlined(
                    title: "Inregistreaza",
                    onClick: {}
                )
            }
        }
    }
}

#Preview {
    RegisterScreen()
}
