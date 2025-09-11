//
//  RegisterScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject private var session: SessionManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    func handleRegister() {
        Task {
            await session.register(
                email: email,
                password: password,
                roleName: "client"
            )
        }
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "register"),
            subHeadline: String(localized: "registerMessage"),
            enableBottomButton: false,
        ) {
            Input(
                label: String(localized: "email"),
                text: $email,
                placeholder: String(localized: "email"),
                keyboardType: .emailAddress,
            )
            
            Input(
                label: String(localized: "password"),
                text: $password,
                placeholder: String(localized: "password"),
                keyboardType: .emailAddress,
            )
            
            MainButton(
                title: String(localized: "register"),
                onClick: handleRegister,
                isDisabled: session.isLoading,
                isLoading: session.isLoading
            )
            
            HStack {
                Text("alreadyHaveAnAccount")
                NavigationLink("register") {
                    LoginScreen()
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
