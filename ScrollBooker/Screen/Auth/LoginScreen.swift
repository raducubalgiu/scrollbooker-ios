//
//  LoginScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct LoginScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        FormLayout(
            headline: String(localized: "login"),
            subHeadline: String(localized: "loginMessage"),
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
                title: "Logare",
                onClick: {  }
            )
            
            HStack {
                Text("dontHaveAnAccount")
                NavigationLink(
                    "register"
                ) {
                    RegisterScreen()
                }
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

#Preview("Light") {
    LoginScreen()
}

#Preview("Dark") {
    LoginScreen()
        .preferredColorScheme(.dark)
}
