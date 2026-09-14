//
//  SessionManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import Foundation
import Observation
import Combine

enum RootDestination { case splash, auth, main }

@Observable
@MainActor
final class SessionManager {
    private let store: AuthStore

    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let refreshSessionUseCase: RefreshSessionUseCase
    private let verifyEmailUseCase: VerifyEmailUseCase
    private let saveSessionUseCase: SaveSessionUseCase
    private let isLoggedInUseCase: IsLoggedInUseCase

    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()

    private(set) var auth: AuthSnapshot
    private(set) var userInfo: UserInfo? = nil
    var isLoading = false
    var loginError: String?

    private(set) var isInitialized = false
    private(set) var isAuthenticated = false
    var startDestination: RootDestination = .splash

    @ObservationIgnored
    private var refreshTask: Task<Void, Error>?

    var accessToken: String? {
        auth.accessToken
    }

    init(
        store: AuthStore = AuthStore(),
        loginUseCase: LoginUseCase,
        registerUseCase: RegisterUseCase,
        refreshSessionUseCase: RefreshSessionUseCase,
        verifyEmailUseCase: VerifyEmailUseCase,
        saveSessionUseCase: SaveSessionUseCase,
        isLoggedInUseCase: IsLoggedInUseCase
    ) {
        self.store = store
        self.auth = store.initialSnapshot

        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.refreshSessionUseCase = refreshSessionUseCase
        self.verifyEmailUseCase = verifyEmailUseCase
        self.saveSessionUseCase = saveSessionUseCase
        self.isLoggedInUseCase = isLoggedInUseCase

        // Reactive sync cu UI
        store.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snap in
                self?.auth = snap
                self?.isAuthenticated = snap.isAuthenticated
            }
            .store(in: &cancellables)
    }

    func updateAuthState(_ authState: AuthState) {
        guard let currentUserInfo = userInfo else { return }

        userInfo = UserInfo(
            id: currentUserInfo.id,
            username: currentUserInfo.username,
            fullName: currentUserInfo.fullName,
            profession: currentUserInfo.profession,
            avatar: currentUserInfo.avatar,
            businessId: currentUserInfo.businessId,
            businessOwnerId: currentUserInfo.businessOwnerId,
            businessTypeId: currentUserInfo.businessTypeId,
            hasEmployees: currentUserInfo.hasEmployees,
            isValidated: authState.isValidated,
            registrationStep: authState.registrationStep
        )
    }

    // MARK: - Bootstrap (Flow-ul de pornire al aplicației)
    func bootstrap() async {
        defer { isInitialized = true }

        let result = await isLoggedInUseCase()

        switch result {
        case .authenticated(let info):
            self.userInfo = info
            self.isAuthenticated = true
        case .loggedOut:
            self.userInfo = nil
            self.isAuthenticated = false
        }
    }

    func login(username: String, password: String) async {
        isLoading = true
        loginError = nil

        do {
            let authResponse = try await loginUseCase(username: username, password: password)
            let info = try await saveSessionUseCase(authResponse: authResponse)

            self.userInfo = info
            self.isAuthenticated = true

        } catch {
            self.loginError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.isAuthenticated = false
            await store.clearUserSession()
        }

        isLoading = false
    }

    // MARK: - Register Flow
    func register(email: String, password: String, roleName: String) async {
        isLoading = true
        loginError = nil

        do {
            let authResponse = try await registerUseCase(email: email, password: password, roleName: roleName)
            let info = try await saveSessionUseCase(authResponse: authResponse)

            self.userInfo = info
            self.isAuthenticated = true

        } catch {
            self.loginError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.isAuthenticated = false
            await store.clearUserSession()
        }

        isLoading = false
    }

    // MARK: - Global Token Refresh (Apelat automat de AuthInterceptor la erori 401)
    func refreshSession() async throws {
        if let existingTask = refreshTask {
            _ = try await existingTask.value
            return
        }

        guard let refreshToken = auth.refreshToken, !refreshToken.isEmpty else {
            throw APIError.unauthorized
        }

        let task = Task<Void, Error> {
            let refresh = try await refreshSessionUseCase(refreshToken: refreshToken)

            await store.refreshTokens(
                accessToken: refresh.accessToken,
                refreshToken: refresh.refreshToken
            )
        }

        self.refreshTask = task

        defer { self.refreshTask = nil }

        _ = try await task.value
    }

    func logout() {
        Task { await store.clearUserSession() }
        self.userInfo = nil
        isAuthenticated = false
    }

    func verifyEmail() async {
        guard let token = auth.accessToken, !token.isEmpty else {
            isAuthenticated = false
            userInfo = nil
            return
        }

        isLoading = true
        loginError = nil

        do {
            let authState = try await verifyEmailUseCase()
            updateAuthState(authState)
        } catch {
            self.loginError = (error as? LocalizedError)?.errorDescription
        }

        isLoading = false
    }
}
