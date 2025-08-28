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
            headline: String(localized: "register"),
            subHeadline: String(localized: "registerMessage"),
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
            
            HStack {
                Text("alreadyHaveAnAccount")
                Button("Login") {
                    
                }
                .foregroundColor(.primarySB)
                .fontWeight(.bold)
            }
            
            VStack {
                Spacer()
                
                Divider()
                
                Text("doYouHaveABusinessWhichReceivesAppointments")
                    .padding(.vertical)
                
                MainButtonOutlined(
                    title: String(localized: "registerNow"),
                    onClick: {}
                )
            }
        }
    }
}

#Preview {
    RegisterScreen()
}
