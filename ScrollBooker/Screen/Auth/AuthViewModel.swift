//
//  AuthViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import OSLog
import UIKit
import GoogleSignIn

@Observable
@MainActor
final class AuthViewModel {
    private let session: SessionManager
    private let toastCenter: ToastCenter
    private let signInWithGoogleUseCase: SignInWithGoogleUseCase
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let verifyEmailUseCase: VerifyEmailUseCase
    private let resendVerificationEmailUseCase: ResendVerificationEmailUseCase
    private let saveSessionUseCase: SaveSessionUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Auth")

    var isLoading = false
    var loginError: String?
    var isResendingVerificationEmail = false

    init(
        session: SessionManager,
        toastCenter: ToastCenter,
        signInWithGoogleUseCase: SignInWithGoogleUseCase,
        loginUseCase: LoginUseCase,
        registerUseCase: RegisterUseCase,
        verifyEmailUseCase: VerifyEmailUseCase,
        resendVerificationEmailUseCase: ResendVerificationEmailUseCase,
        saveSessionUseCase: SaveSessionUseCase
    ) {
        self.session = session
        self.toastCenter = toastCenter
        self.signInWithGoogleUseCase = signInWithGoogleUseCase
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.verifyEmailUseCase = verifyEmailUseCase
        self.resendVerificationEmailUseCase = resendVerificationEmailUseCase
        self.saveSessionUseCase = saveSessionUseCase
    }

    func login(identifier: String, password: String) async {
        isLoading = true

        do {
            let authResponse = try await loginUseCase(username: identifier, password: password)
            let info = try await saveSessionUseCase(authResponse: authResponse)
            session.setAuthenticated(info)
        } catch {
            toastCenter.show(loginErrorMessage(for: error), type: .error)
            await session.clearSession()
        }

        isLoading = false
    }

    private func loginErrorMessage(for error: Error) -> String {
        switch (error as? APIError)?.backendDetail {
        case "This user is not registered yet":
            return String(localized: "auth_error_user_not_found")
        case "This account uses Google Sign-In. Please use Google to log in.":
            return String(localized: "auth_error_google_account")
        case "Invalid username or password":
            return String(localized: "auth_error_invalid_credentials")
        default:
            return String(localized: "auth_error_generic")
        }
    }

    func signInWithGoogle(roleName: RoleName) async {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        
        isLoading = true
        loginError = nil
        
        do {
            let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = signInResult.user
            
            guard let idToken = user.idToken?.tokenString else {
                isLoading = false
                return
            }
            
            let authResponse = try await signInWithGoogleUseCase(idToken: idToken, roleName: roleName.rawValue)
            let info = try await saveSessionUseCase(authResponse: authResponse)
            
            session.setAuthenticated(info)
            
        } catch {
            loginError = logger.userMessage(for: error, context: "Google Sign In")
            await session.clearSession()
        }
        
        isLoading = false
    }


    func register(email: String, password: String, roleName: String) async {
        isLoading = true

        do {
            let authResponse = try await registerUseCase(email: email, password: password, roleName: roleName)
            let info = try await saveSessionUseCase(authResponse: authResponse)
            session.setAuthenticated(info)
        } catch {
            toastCenter.show(registerErrorMessage(for: error), type: .error)
            await session.clearSession()
        }

        isLoading = false
    }

    private func registerErrorMessage(for error: Error) -> String {
        switch (error as? APIError)?.backendDetail {
        case "User already registered":
            return String(localized: "auth_error_email_taken")
        default:
            return String(localized: "auth_error_generic")
        }
    }

    func verifyEmail(code: String) async {
        isLoading = true

        do {
            let authState = try await withLoading {
                try await self.verifyEmailUseCase(code: code)
            }
            session.updateAuthState(authState)
        } catch {
            _ = logger.userMessage(for: error, context: "Verifying Email")
            toastCenter.show(verifyEmailErrorMessage(for: error), type: .error)
        }

        isLoading = false
    }

    func resendVerificationEmail() async {
        isResendingVerificationEmail = true

        do {
            let detail = try await withLoading {
                try await self.resendVerificationEmailUseCase()
            }

            if detail == "Email already verified" {
                toastCenter.show(String(localized: "onboarding_email_verification_already_verified"))
            } else {
                toastCenter.show(String(localized: "onboarding_email_verification_resend_success"))
            }
        } catch {
            _ = logger.userMessage(for: error, context: "Resending Verification Email")
            toastCenter.show(String(localized: "onboarding_email_verification_error_generic"), type: .error)
        }

        isResendingVerificationEmail = false
    }

    private func verifyEmailErrorMessage(for error: Error) -> String {
        switch (error as? APIError)?.backendDetail {
        case "Incorrect code":
            return String(localized: "onboarding_email_verification_error_incorrect_code")
        case "Too many attempts, request a new code":
            return String(localized: "onboarding_email_verification_error_too_many_attempts")
        case "Code invalid or expired":
            return String(localized: "onboarding_email_verification_error_expired_code")
        default:
            return String(localized: "onboarding_email_verification_error_generic")
        }
    }
}
