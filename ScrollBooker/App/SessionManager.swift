//
//  SessionManager.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI
import Combine

//@MainActor
//final class AppState: ObservableObject {
//    static let shared = AppState()
//    
//    @Published var isInitialized = false
//    @Published var isAuthenticated = false
//    @Published var startDestination: RootDestination = .splash
//}

enum RootDestination { case splash, auth, main }

@MainActor
final class SessionManager: ObservableObject {
    // MARK: API
    private let client: APIClient
    private lazy var authAPI: AuthAPI = AuthAPIImpl(client: client)
    private lazy var userInfoAPI: UserInfoAPI = UserInfoAPIImpl(client: client)
    
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
        
        do {
            let info = try await userInfoAPI.userInfo(bearer: token)
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
            // 1) Login
            let login = try await authAPI.login(.init(username: username, password: password))
            
            // 2) /user-info (cu tokenul nou)
            let info = try await userInfoAPI.userInfo(bearer: login.accessToken)
            
            // 3) persist & state
            await store.storeUserSession(
                accessToken: login.accessToken,
                refreshToken: login.refreshToken,
                userId: info.id,
                username: info.username,
                fullName: info.fullName,
                businessId: info.businessId,
                businessTypeId: info.businessTypeId,
                permissions: []
            )
            self.userInfo = info
           isAuthenticated = true
            
        } catch {
            self.loginError = (error as? LocalizedError)?.errorDescription
            isAuthenticated = false
        }
        isLoading = false
    }
    
    func didLogin(token: String,
                  refresh: String,
                  info: UserInfo,
                  permissions: [String]
    ) {
        Task {
            await store.storeUserSession(
                accessToken: token,
                refreshToken: refresh,
                userId: info.id,
                username: info.username,
                fullName: info.fullName,
                businessId: info.businessId,
                businessTypeId: info.businessTypeId,
                permissions: permissions
            )
        }
        self.userInfo = info
        isAuthenticated = true
    }
    
    func refreshTokens(access: String, refresh: String) {
        Task {
            await store.refreshTokens(
                accessToken: access,
                refreshToken: refresh
            )
        }
    }
    
    func logout() {
        Task { await store.clearUserSession() }
        self.userInfo = nil
        isAuthenticated = false
    }
}
