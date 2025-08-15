//
//  SessionManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()
    @Published var isInitialized = false
    @Published var isAuthenticated = false
    @Published var startDestination: RootDestination = .splash
}

enum RootDestination { case splash, auth, main }

@MainActor
final class SessionManager: ObservableObject {
    @Published var accessToken: String? = nil
    @Published var userId: Int? = nil
    
    func bootstrap() async {
        // 1) Incarca token din Keychain, valideaza, ia userPermissions etc
        // 2) Seteaza AppState corespunzator
        try? await Task.sleep(nanoseconds: 200_000_000) // mock
        
        if let token = accessToken, !token.isEmpty {
            AppState.shared.isAuthenticated = true
            AppState.shared.startDestination = .main
        } else {
            AppState.shared.isAuthenticated = false
            AppState.shared.startDestination = .auth
        }
        
        AppState.shared.isInitialized = true
    }
    
    func login(mock: Bool = true) async {
        // Do login, apoi:
        self.accessToken = "token"
        AppState.shared.isAuthenticated = true
        AppState.shared.startDestination = .main
    }
    
    func logout() {
//        accessToken = null
//        AppState.shared.isAuthenticated = false
//        AppState.shared.startDestination = .auth
    }
}
