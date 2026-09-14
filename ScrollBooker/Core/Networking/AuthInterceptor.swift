//
//  AuthInterceptor.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    weak var sessionManager: SessionManager?

    init(sessionManager: SessionManager? = nil) {
        self.sessionManager = sessionManager
    }
    
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var mutableRequest = request
        
        if let path = request.url?.path.lowercased(), path.contains("/auth/refresh") {
            return mutableRequest
        }

        if let token = await sessionManager?.accessToken, !token.isEmpty {
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return mutableRequest
    }
    
    func retry(_ request: URLRequest, dueTo error: Error, attempts: Int) async throws -> Bool {
        guard attempts <= 1 else { return false }

        if let path = request.url?.path.lowercased(), path.contains("/auth/refresh") {
            return false
        }

        guard isUnauthorized(error) else { return false }
        guard let sessionManager = sessionManager else { return false }

        do {
            try await sessionManager.refreshSession()
            return true
        } catch {
            await sessionManager.logout()
            return false
        }
    }

    /// Un 401 real de la server ajunge ca `.server(status: 401, _)`, nu ca
    /// `.unauthorized` — acel caz e aruncat doar sintetic (ex. lipsă refresh
    /// token). Trebuie tratate amândouă ca "sesiunea nu mai e validă".
    private func isUnauthorized(_ error: Error) -> Bool {
        guard let apiError = error as? APIError else { return false }
        switch apiError {
        case .unauthorized: return true
        case .server(let status, _): return status == 401
        default: return false
        }
    }
}
