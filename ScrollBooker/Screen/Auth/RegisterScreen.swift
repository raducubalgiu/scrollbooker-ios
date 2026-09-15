//
//  RegisterScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct RegisterScreen: View {
    let authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showRegisterBusiness = false

    var body: some View {
        FormLayout(
            headline: String(localized: "register"),
            subHeadline: String(localized: "registerMessage"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                Input(
                    label: String(localized: "email"),
                    text: $email,
                    placeholder: String(localized: "email"),
                    keyboardType: .emailAddress,
                )
                .textInputAutocapitalization(.never)

                Input(
                    label: String(localized: "password"),
                    text: $password,
                    placeholder: String(localized: "password"),
                    isSecure: true
                )

                MainButton(
                    title: String(localized: "register"),
                    isDisabled: authViewModel.isLoading,
                    isLoading: authViewModel.isLoading,
                    onClick: {
                        Task {
                            await authViewModel.register(
                                email: email,
                                password: password,
                                roleName: "client"
                            )
                        }
                    },
                )
                .padding(.top, .xs)

                HStack {
                    Text("alreadyHaveAnAccount")
                    NavigationLink("register") {
                        LoginScreen(authViewModel: authViewModel)
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
