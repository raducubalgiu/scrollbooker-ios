//
//  SessionManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import Combine

enum RootDestination { case splash, auth, main }

@MainActor
final class SessionManager: ObservableObject {
    // MARK: API
    private let client: APIClient
    
    private lazy var authAPI: AuthAPI = AuthAPIImpl(client: client)
    private lazy var userAPI: UserAPI = UserAPIImpl(client: client)
    
    // MARK: Store & State
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var auth: AuthSnapshot
    @Published private(set) var userInfo: UserInfo? = nil
    @Published var isLoading = false
    @Published var loginError: String?
    
    @Published private(set) var isInitialized = false
    @Published private(set) var isAuthenticated = false
    @Published var startDestination: RootDestination = .splash
    
    init(store: AuthStore = AuthStore(), client: APIClient) {
        self.client = client
        self.store = store
        self.auth = store.initialSnapshot
        
        // reactive sync cu UI / RootRouter
        store.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snap in
                self?.auth = snap
                self?.isAuthenticated = snap.isAuthenticated
            }
            .store(in: &cancellables)
    }
    
    func bootstrap() async {
        defer { isInitialized = true }
        
        guard let token = auth.accessToken, !token.isEmpty else {
            isAuthenticated = false
            userInfo = nil
            return
        }
        
        guard let refreshToken = auth.refreshToken, !refreshToken.isEmpty else {
            isAuthenticated = false
            userInfo = nil
            return
        }
        
        do {
            // Verify token expiration
            if isTokenExpired(token) {
                // Try to refresh
                let refresh = try await authAPI.refresh(refreshToken: refreshToken)
                
                // 2) Get User Info - new token
                let info = try await userAPI.userInfo(token: refresh.accessToken)
                
                // 3) Get User Permissions
                let permissions = try await userAPI.userPermission(token: refresh.accessToken)
                let permissionCodes = permissions.map { $0.code }
                
                // 4) persist & state
                await store.storeUserSession(
                    accessToken: refresh.accessToken,
                    refreshToken: refresh.refreshToken,
                    userId: info.id,
                    username: info.username,
                    fullName: info.fullName,
                    businessId: info.businessId,
                    businessTypeId: info.businessTypeId,
                    permissions: permissionCodes
                )
                self.userInfo = info
                
                isAuthenticated = true
                
            } else {
                // Get User Info
                let info = try await userAPI.userInfo(token: token)
                self.userInfo = info
                
                isAuthenticated = true
            }
        } catch {
            await store.clearUserSession()
            self.userInfo = nil
            
            isAuthenticated = false
        }
    }
    
    func login(username: String, password: String) async {
        isLoading = true
        loginError = nil
        
        do {
            // 1) Login
            let login = try await authAPI.login(.init(username: username, password: password))
            
            // 2) Get User Info - new token
            let info = try await userAPI.userInfo(token: login.accessToken)
            
            // 3) Get User Permissions
            let permissions = try await userAPI.userPermission(token: login.accessToken)
            let permissionCodes = permissions.map { $0.code }
            
            // 4) persist & state
            await store.storeUserSession(
                accessToken: login.accessToken,
                refreshToken: login.refreshToken,
                userId: info.id,
                username: info.username,
                fullName: info.fullName,
                businessId: info.businessId,
                businessTypeId: info.businessTypeId,
                permissions: permissionCodes
            )
            self.userInfo = info
           isAuthenticated = true
            
        } catch {
            self.loginError = (error as? LocalizedError)?.errorDescription
            isAuthenticated = false
        }
        isLoading = false
    }
    
    func logout() {
        Task { await store.clearUserSession() }
        
        self.userInfo = nil
        isAuthenticated = false
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
