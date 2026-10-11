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

    func login(username: String, password: String) async {
        isLoading = true
        loginError = nil

        do {
            let authResponse = try await loginUseCase(username: username, password: password)
            let info = try await saveSessionUseCase(authResponse: authResponse)
            session.setAuthenticated(info)
        } catch {
            loginError = logger.userMessage(for: error, context: "Login")
            await session.clearSession()
        }

        isLoading = false
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
        loginError = nil

        do {
            let authResponse = try await registerUseCase(email: email, password: password, roleName: roleName)
            let info = try await saveSessionUseCase(authResponse: authResponse)
            session.setAuthenticated(info)
        } catch {
            loginError = logger.userMessage(for: error, context: "Register")
            await session.clearSession()
        }

        isLoading = false
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
        if case .server(_, let data)? = error as? APIError, let data,
           let detail = try? JSONDecoder().decode(ActionMessageResponseDTO.self, from: data).detail {
            switch detail {
            case "Incorrect code":
                return String(localized: "onboarding_email_verification_error_incorrect_code")
            case "Too many attempts, request a new code":
                return String(localized: "onboarding_email_verification_error_too_many_attempts")
            case "Code invalid or expired":
                return String(localized: "onboarding_email_verification_error_expired_code")
            default:
                break
            }
        }
        return String(localized: "onboarding_email_verification_error_generic")
    }
}
