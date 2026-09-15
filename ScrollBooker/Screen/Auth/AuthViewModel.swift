//
//  AuthViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class AuthViewModel {
    private let session: SessionManager
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let verifyEmailUseCase: VerifyEmailUseCase
    private let saveSessionUseCase: SaveSessionUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Auth")

    var isLoading = false
    var loginError: String?

    init(
        session: SessionManager,
        loginUseCase: LoginUseCase,
        registerUseCase: RegisterUseCase,
        verifyEmailUseCase: VerifyEmailUseCase,
        saveSessionUseCase: SaveSessionUseCase
    ) {
        self.session = session
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.verifyEmailUseCase = verifyEmailUseCase
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

    func verifyEmail() async {
        guard let token = session.accessToken, !token.isEmpty else {
            await session.clearSession()
            return
        }

        isLoading = true
        loginError = nil

        do {
            let authState = try await withLoading {
                try await self.verifyEmailUseCase()
            }
            session.updateAuthState(authState)
        } catch {
            loginError = logger.userMessage(for: error, context: "Verifying Email")
        }

        isLoading = false
    }
}
