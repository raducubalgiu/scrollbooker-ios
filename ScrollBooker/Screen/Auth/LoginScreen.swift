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
    
    func handleLogin() {
        Task {
            await session.login(
                username: username,
                password: password
            )
        }
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "login"),
            subHeadline: String(localized: "loginMessage"),
            enableBottomButton: false,
        ) {
            Input(
                label: String(localized: "username"),
                text: $username,
                placeholder: "Username",
            )
            
            Input(
                label: String(localized: "password"),
                text: $password,
                placeholder: String(localized: "password"),
            )
            
            MainButton(
                title: String(localized: "login"),
                onClick: handleLogin,
                isDisabled: session.isLoading,
                isLoading: session.isLoading
            )
            
            HStack {
                Text("dontHaveAnAccount")
                NavigationLink("register") {
                    RegisterScreen()
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

#Preview("Light") {
    LoginScreen()
        .environmentObject(SessionManager())
}

#Preview("Dark") {
    LoginScreen()
        .environmentObject(SessionManager())
        .preferredColorScheme(.dark)
}
