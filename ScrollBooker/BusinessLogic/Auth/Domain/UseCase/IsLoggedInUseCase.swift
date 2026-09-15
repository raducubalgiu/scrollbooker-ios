//
//  IsLoggedInUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation
import OSLog

/// Verifică la pornirea aplicației dacă sesiunea salvată local e încă validă.
///
/// Distincție importantă: o eroare de transport (`URLError` — fără internet,
/// timeout, DNS) NU înseamnă că sesiunea e invalidă, doar că nu am putut-o
/// verifica acum. În acest caz avem încredere în identitatea cache-uită local
/// (`cachedUserInfo`) și lăsăm utilizatorul autentificat, ca pe Instagram —
/// nu îl delogăm doar pentru că nu are semnal. Doar un eșec confirmat de
/// server (401 chiar și după refresh, sau alt răspuns explicit invalid)
/// duce la delogare reală.
final class IsLoggedInUseCase {
    private let store: AuthStore
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let getUserPermissionsUseCase: GetUserPermissionsUseCase
    private let refreshSessionUseCase: RefreshSessionUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Session")

    init(
        store: AuthStore,
        getUserInfoUseCase: GetUserInfoUseCase,
        getUserPermissionsUseCase: GetUserPermissionsUseCase,
        refreshSessionUseCase: RefreshSessionUseCase
    ) {
        self.store = store
        self.getUserInfoUseCase = getUserInfoUseCase
        self.getUserPermissionsUseCase = getUserPermissionsUseCase
        self.refreshSessionUseCase = refreshSessionUseCase
    }

    func callAsFunction() async -> SessionCheckResult {
        let snapshot = await store.current()

        guard let accessToken = snapshot.accessToken, !accessToken.isEmpty,
              let refreshToken = snapshot.refreshToken, !refreshToken.isEmpty else {
            return .loggedOut
        }

        do {
            if isTokenExpired(accessToken) {
                let refreshed = try await refreshSessionUseCase(refreshToken: refreshToken)
                await store.refreshTokens(accessToken: refreshed.accessToken, refreshToken: refreshed.refreshToken)
            }

            async let userInfoTask = getUserInfoUseCase()
            async let permissionsTask = getUserPermissionsUseCase()
            let (userInfo, permissions) = try await (userInfoTask, permissionsTask)

            await store.updateUserSession(userInfo: userInfo, permissions: permissions.map(\.code))

            return .authenticated(userInfo)

        } catch {
            if error is URLError {
                // Eroare de transport — nu am ajuns la server. Avem încredere în cache.
                logger.notice("Bootstrap fără conexiune — folosim identitatea din cache: \(error.localizedDescription, privacy: .public)")

                if let cached = snapshot.cachedUserInfo {
                    return .authenticated(cached)
                }
                return .loggedOut
            }

            // Eroare confirmată de server (401 etc.) — sesiunea chiar nu mai e validă.
            logger.error("ERROR: on Checking Session, clearing session: \(error.localizedDescription, privacy: .public)")
            await store.clearUserSession()
            return .loggedOut
        }
    }

    private func isTokenExpired(_ token: String, skewSeconds: TimeInterval = 60) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count >= 2 else { return true }

        var base64 = parts[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        while base64.count % 4 != 0 {
            base64.append("=")
        }

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return true
        }

        let expirationDate = Date(timeIntervalSince1970: exp)
        return Date().addingTimeInterval(skewSeconds) >= expirationDate
    }
}
