//
//  AuthInterceptor.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    // Folosim o referință slabă (weak) pentru a preveni ciclurile de retenție de memorie (Retain Cycles).
    private weak var sessionManager: SessionManager?
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var mutableRequest = request
        
        // Dacă sesiunea are un token valid, îl injectăm automat în Header.
        if let token = await sessionManager?.accessToken, !token.isEmpty {
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return mutableRequest
    }
    
    func retry(_ request: URLRequest, dueTo error: Error, attempts: Int) async throws -> Bool {
        // Limităm reîncercările pentru a preveni loop-urile infinite în cazul în care serverul e picat.
        guard attempts <= 1 else { return false }
        
        // Dacă eroarea este de tip unauthorized (401), declanșăm procesul de Refresh Token.
        if let apiError = error as? APIError, case .unauthorized = apiError {
            guard let sessionManager = sessionManager else { return false }
            
            do {
                // Aici se apelează logica ta din SessionManager care reîmprospătează token-ul (ex: prin Refresh Token).
                try await sessionManager.refreshSession()
                return true // Reîncercăm cererea inițială cu noul token injectat!
            } catch {
                // Dacă și refresh-ul eșuează, deconectăm utilizatorul forțat.
                await sessionManager.logout()
                return false
            }
        }
        
        return false // Pentru orice altă eroare (ex: 404), nu facem retry.
    }
}
