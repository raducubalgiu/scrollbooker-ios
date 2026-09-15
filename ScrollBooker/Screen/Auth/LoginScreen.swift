//
//  LoginScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct LoginScreen: View {
    let authViewModel: AuthViewModel

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showRegisterBusiness = false

    private var lowercasedUsername: Binding<String> {
        Binding(
            get: { username },
            set: { username = $0.lowercased() }
        )
    }

    var body: some View {
        FormLayout(
            headline: String(localized: "login"),
            subHeadline: String(localized: "loginMessage"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                Input(
                    label: String(localized: "usernameOrEmail"),
                    text: lowercasedUsername,
                    placeholder: String(localized: "usernameOrEmail"),
                )
                .textInputAutocapitalization(.never)

                Input(
                    label: String(localized: "password"),
                    text: $password,
                    placeholder: String(localized: "password"),
                    isSecure: true
                )

                MainButton(
                    title: String(localized: "login"),
                    isDisabled: authViewModel.isLoading,
                    isLoading: authViewModel.isLoading,
                    onClick: {
                        Task {
                            await authViewModel.login(
                                username: username,
                                password: password
                            )
                        }
                    },
                )
                .padding(.top, .xs)

                HStack {
                    Text("dontHaveAnAccount")
                    NavigationLink("register") {
                        RegisterScreen(authViewModel: authViewModel)
                    }
                    .foregroundColor(.primarySB)
                    .fontWeight(.bold)
                }

                VStack(alignment: .center, spacing: AppSize.s.rawValue) {
                    Spacer()

                    Divider()

                    Text("doYouHaveABusinessWhichReceivesAppointments")

                    MainButtonOutlined(
                        title: String(localized: "registerNow"),
                        onClick: { showRegisterBusiness = true }
                    )
                }
            }
            .padding(.horizontal, .xl)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationDestination(isPresented: $showRegisterBusiness) {
            RegisterBusinessScreen(authViewModel: authViewModel)
        }
    }
}
