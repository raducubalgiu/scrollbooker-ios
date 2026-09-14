//
//  IsLoggedInUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

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
    private let refreshSessionUseCase: RefreshSessionUseCase

    init(
        store: AuthStore,
        getUserInfoUseCase: GetUserInfoUseCase,
        refreshSessionUseCase: RefreshSessionUseCase
    ) {
        self.store = store
        self.getUserInfoUseCase = getUserInfoUseCase
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

            let userInfo = try await getUserInfoUseCase()
            return .authenticated(userInfo)

        } catch {
            if error is URLError {
                // Eroare de transport — nu am ajuns la server. Avem încredere în cache.
                if let cached = snapshot.cachedUserInfo {
                    return .authenticated(cached)
                }
                return .loggedOut
            }

            // Eroare confirmată de server (401 etc.) — sesiunea chiar nu mai e validă.
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
