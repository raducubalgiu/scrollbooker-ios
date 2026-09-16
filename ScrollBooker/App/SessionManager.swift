//
//  SessionManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import Foundation
import Observation
import Combine
import OSLog

enum RootDestination { case splash, auth, main }

@Observable
@MainActor
final class SessionManager {
    private let store: AuthStore
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Session")

    private let refreshSessionUseCase: RefreshSessionUseCase
    private let isLoggedInUseCase: IsLoggedInUseCase

    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()

    private(set) var auth: AuthSnapshot
    private(set) var userInfo: UserInfo? = nil

    private(set) var isInitialized = false
    private(set) var isAuthenticated = false
    var startDestination: RootDestination = .splash

    @ObservationIgnored
    private var refreshTask: Task<Void, Error>?

    var accessToken: String? {
        auth.accessToken
    }

    var permissions: [PermissionEnum] {
        PermissionEnum.fromKeys(auth.permissions)
    }

    func hasPermission(_ permission: PermissionEnum) -> Bool {
        permissions.has(permission)
    }

    init(
        store: AuthStore = AuthStore(),
        refreshSessionUseCase: RefreshSessionUseCase,
        isLoggedInUseCase: IsLoggedInUseCase
    ) {
        self.store = store
        self.auth = store.initialSnapshot

        self.refreshSessionUseCase = refreshSessionUseCase
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

    func setAuthenticated(_ userInfo: UserInfo) {
        self.userInfo = userInfo
        self.isAuthenticated = true
    }

    func clearSession() async {
        await store.clearUserSession()
        self.userInfo = nil
        self.isAuthenticated = false
    }

    func updateAvatar(_ avatarURL: String) {
        guard let currentUserInfo = userInfo else { return }

        userInfo = UserInfo(
            id: currentUserInfo.id,
            username: currentUserInfo.username,
            fullName: currentUserInfo.fullName,
            profession: currentUserInfo.profession,
            avatar: avatarURL,
            businessId: currentUserInfo.businessId,
            businessOwnerId: currentUserInfo.businessOwnerId,
            businessTypeId: currentUserInfo.businessTypeId,
            hasEmployees: currentUserInfo.hasEmployees,
            isValidated: currentUserInfo.isValidated,
            registrationStep: currentUserInfo.registrationStep
        )
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

        do {
            _ = try await task.value
        } catch {
            logger.error("ERROR: on Refreshing Session: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    func logout() {
        Task { await clearSession() }
    }
}
