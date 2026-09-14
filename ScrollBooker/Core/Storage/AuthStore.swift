//
//  AuthStore.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation
import Combine

actor AuthStore {
    // MARK: Keys
    private enum K {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let permissions = "permissions" // JSON array
        static let cachedUserInfo = "cachedUserInfo" // JSON-encoded UserInfo, for offline bootstrap
    }

    // MARK: Dependencies
    private let defaults: UserDefaults
    private let service: String

    // MARK: In-Memory cache (super rapid)
    private var snapshot: AuthSnapshot

    // public, accesibil fara await (e un let setat in init)
    nonisolated let initialSnapshot: AuthSnapshot

    // MARK: Publishers (Bridge spre UI)
    private nonisolated let subject: CurrentValueSubject<AuthSnapshot, Never>

    // MARK: Public Publiser (Non-Isolated)
    nonisolated var publisher: AnyPublisher<AuthSnapshot, Never> {
        subject.eraseToAnyPublisher()
    }

    // MARK: Init - Incarcam o singura data din I/O
    init(defaults: UserDefaults = .standard, service: String = Bundle.main.bundleIdentifier ?? "app") {
        self.defaults = defaults
        self.service = service

        // read once (I/O)
        let access = (try? Keychain.get(K.accessToken, service: service)) ?? nil
        let refresh = (try? Keychain.get(K.refreshToken, service: service)) ?? nil
        let cachedUserInfo: UserInfo? = {
            guard let data = defaults.data(forKey: K.cachedUserInfo) else { return nil }
            return try? JSONDecoder().decode(UserInfo.self, from: data)
        }()
        let permissions: [String] = {
            if let data = defaults.data(forKey: K.permissions),
               let arr = try? JSONDecoder().decode([String].self, from: data) { return arr }
            return []
        }()

        let snap = AuthSnapshot(
            accessToken: access,
            refreshToken: refresh,
            cachedUserInfo: cachedUserInfo,
            permissions: permissions
        )
        self.snapshot = snap
        self.initialSnapshot = snap
        self.subject = CurrentValueSubject(snap)
    }

    // Store entire Session (write-through; persist off-main)
    func storeUserSession(
        accessToken: String,
        refreshToken: String,
        userInfo: UserInfo,
        permissions: [String]
    ) {
        // update cache
        snapshot.accessToken = accessToken
        snapshot.refreshToken = refreshToken
        snapshot.cachedUserInfo = userInfo
        snapshot.permissions = permissions
        subject.send(snapshot)

        // persist off-main (nu blocam UI)
        Task.detached { [defaults, service] in
            try? Keychain.set(accessToken, key: K.accessToken, service: service)
            try? Keychain.set(refreshToken, key: K.refreshToken, service: service)

            if let data = try? JSONEncoder().encode(userInfo) {
                defaults.set(data, forKey: K.cachedUserInfo)
            }
            if let data = try? JSONEncoder().encode(permissions) {
                defaults.set(data, forKey: K.permissions)
            }
        }
    }

    func current() -> AuthSnapshot { snapshot }

    func refreshTokens(accessToken: String, refreshToken: String) {
        snapshot.accessToken = accessToken
        snapshot.refreshToken = refreshToken
        subject.send(snapshot)

        Task.detached { [service] in
            try? Keychain.set(accessToken, key: K.accessToken, service: service)
            try? Keychain.set(refreshToken, key: K.refreshToken, service: service)
        }
    }

    func clearUserSession() {
        snapshot = AuthSnapshot()
        subject.send(snapshot)

        Task.detached { [defaults, service] in
            try? Keychain.set(nil, key: K.accessToken, service: service)
            try? Keychain.set(nil, key: K.refreshToken, service: service)

            [K.cachedUserInfo, K.permissions].forEach { defaults.removeObject(forKey: $0) }
        }
    }
}
