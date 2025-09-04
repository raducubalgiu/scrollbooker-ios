//
//  LoginScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var session: SessionManager
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        FormLayout(
            headline: String(localized: "login"),
            subHeadline: String(localized: "loginMessage"),
            enableBottomButton: false,
        ) {
            Input(
                label: "Username",
                text: $username,
                placeholder: "Username",
            )
            
            Input(
                label: "Parola",
                text: $password,
                placeholder: "Parola",
                //keyboardType: .password,
            )
            
            MainButton(
                title: "Logare",
                onClick: {
                    Task {
                        await session.login(
                            username: username,
                            password: password
                        )
                    }
                },
                isDisabled: session.isLoading
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
