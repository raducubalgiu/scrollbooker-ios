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
    private let client: APIClient

    private let authAPI: AuthAPI
    private let userAPI: UserAPI
    
    private let store: AuthStore
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var auth: AuthSnapshot
    @Published private(set) var userInfo: UserInfo? = nil
    @Published var isLoading = false
    @Published var loginError: String?
    
    @Published private(set) var isInitialized = false
    @Published private(set) var isAuthenticated = false
    @Published var startDestination: RootDestination = .splash
    
    private var refreshTask: Task<Void, Error>?
    
    var accessToken: String? {
        auth.accessToken
    }
    
    init(store: AuthStore = AuthStore(), client: APIClient) {
        self.client = client
        self.store = store
        self.auth = store.initialSnapshot
        
        // Inițializăm API-urile curat în init
        self.authAPI = AuthAPIImpl(client: client)
        self.userAPI = UserAPIImpl(client: client)
        
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
        
        guard let token = auth.accessToken, !token.isEmpty,
              let refreshToken = auth.refreshToken, !refreshToken.isEmpty else {
            isAuthenticated = false
            userInfo = nil
            return
        }
        
        do {
            if isTokenExpired(token) {
                try await refreshSession()
            }
            
            let info = try await userAPI.userInfo()
            self.userInfo = info
            isAuthenticated = true
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
            let loginDTO = LoginRequestDTO(username: username, password: password)
            let loginResponse = try await authAPI.login(body: loginDTO)
            
            await store.refreshTokens(
                accessToken: loginResponse.accessToken,
                refreshToken: loginResponse.refreshToken
            )
            
            let info = try await userAPI.userInfo()
            
            let permissions = try await userAPI.userPermission()
            let permissionCodes = permissions.map { $0.code }
            
            // 5) Persistăm starea finală și completă în store
            await store.storeUserSession(
                accessToken: loginResponse.accessToken,
                refreshToken: loginResponse.refreshToken,
                userId: info.id,
                username: info.username,
                fullName: info.fullName,
                businessId: info.businessId,
                businessTypeId: info.businessTypeId,
                permissions: permissionCodes
            )
            
            // 6) Actualizăm UI-ul pe MainActor
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
            let registerDTO = RegisterRequestDTO(email: email, password: password, role_name: roleName)
            let registerResponse = try await authAPI.register(body: registerDTO)
            
            await store.refreshTokens(
                accessToken: registerResponse.accessToken,
                refreshToken: registerResponse.refreshToken
            )
            
            let info = try await userAPI.userInfo()
            
            let permissions = try await userAPI.userPermission()
            let permissionCodes = permissions.map { $0.code }
            
            await store.storeUserSession(
                accessToken: registerResponse.accessToken,
                refreshToken: registerResponse.refreshToken,
                userId: info.id,
                username: info.username,
                fullName: info.fullName,
                businessId: info.businessId,
                businessTypeId: info.businessTypeId,
                permissions: permissionCodes
            )
            
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
            let refresh = try await authAPI.refresh(refreshToken: refreshToken)
            
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
            let authState = try await authAPI.verifyEmail()
            updateAuthState(authState)
        } catch {
            self.loginError = (error as? LocalizedError)?.errorDescription
        }
        
        isLoading = false
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

