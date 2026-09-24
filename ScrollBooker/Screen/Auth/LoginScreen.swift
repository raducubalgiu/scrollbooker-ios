//
//  LoginScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI
import GoogleSignInSwift

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
            subHeadline: String(localized: "auth_description_login"),
            enableBottomButton: false,
            onBack: {}
        ) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                Input(
                    label: String(localized: "auth_label_username_or_email"),
                    text: lowercasedUsername,
                    placeholder: String(localized: "auth_label_username_or_email")
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
                    }
                )
                .padding(.top, .xs)

                VStack(spacing: AppSize.m.rawValue) {
                    // Linia de separare "sau"
                    HStack {
                        VStack { Divider() }
                        Text(String(localized: "auth_or"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, .xs)
                        VStack { Divider() }
                    }
                    .padding(.vertical, .xs)

                    // Butoanele sociale aliniate în linie (Stil Airbnb)
                    HStack(spacing: AppSize.m.rawValue) {
                        
                        // 1. BUTONUL CUSTOM GOOGLE
                        Button {
                            Task {
                                await authViewModel.signInWithGoogle(roleName: .client)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                                    .frame(height: 54)
                                
                                // Poți folosi imaginea din resursele tale (ex: "google_logo")
                                // Dacă nu ai logoul în Assets, poți pune temporar o pictogramă de sistem
                                Image("logo_google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .disabled(authViewModel.isLoading)
                        .opacity(authViewModel.isLoading ? 0.5 : 1.0)

                        // 2. BUTONUL CUSTOM APPLE
                        Button {
                            Task {
                                // Aici vei apela funcția de Apple când o vei implementa
                                print("Apple login tapped")
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                                    .frame(height: 54)
                                
                                // Apple are pictogramă nativă direct în SF Symbols
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primary) // Se adaptează automat la Dark Mode
                            }
                        }
                        .disabled(authViewModel.isLoading)
                        .opacity(authViewModel.isLoading ? 0.5 : 1.0)
                    }
                }

                HStack {
                    Text(String(localized: "auth_description_dont_have_account"))
                    NavigationLink(String(localized: "register")) {
                        RegisterScreen(authViewModel: authViewModel)
                    }
                    .foregroundColor(.primarySB)
                    .fontWeight(.bold)
                }
                .padding(.top, .xs)

                VStack(alignment: .center, spacing: AppSize.s.rawValue) {
                    Spacer()

                    Divider()

                    Text(String(localized: "auth_description_have_business"))

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
