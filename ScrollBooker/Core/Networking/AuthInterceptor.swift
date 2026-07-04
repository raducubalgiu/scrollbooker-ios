//
//  AuthInterceptor.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private weak var sessionManager: SessionManager?
    
    init(sessionManager: SessionManager) {
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

        if let apiError = error as? APIError, case .unauthorized = apiError {
            guard let sessionManager = sessionManager else { return false }

            do {
                try await sessionManager.refreshSession()
                return true
            } catch {
                await sessionManager.logout()
                return false
            }
        }

        return false
    }
}
