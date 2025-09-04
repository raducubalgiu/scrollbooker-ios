//
//  AuthStore.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation
import Combine

public actor AuthStore {
    // MARK: Keys
    private enum K {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let permissions = "permissions" // JSON array
        static let userId = "userId"
        static let username = "username"
        static let fullName = "fullName"
        static let businessId = "businessId"
        static let businessTypeId = "businessTypeId"
    }
    
    // MARK: Dependencies
    private let defaults: UserDefaults
    private let service: String
    
    // MARK: In-Memory cache (super rapid)
    private var snapshot: AuthSnapshot
    
    // public, accesibil fara await (e un let setat in init)
    public nonisolated let initialSnapshot: AuthSnapshot
    
    // MARK: Publishers (Bridge spre UI)
    private nonisolated let subject: CurrentValueSubject<AuthSnapshot, Never>
    
    // MARK: Public Publiser (Non-Isolated)
    public nonisolated var publisher: AnyPublisher<AuthSnapshot, Never> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: Init - Incarcam o singura data din I/O
    public init(defaults: UserDefaults = .standard, service: String = Bundle.main.bundleIdentifier ?? "app") {
        self.defaults = defaults
        self.service = service
        
        // read once (I/O)
        let access = (try? Keychain.get(K.accessToken, service: service)) ?? nil
        let refresh = (try? Keychain.get(K.refreshToken, service: service)) ?? nil
        let userId = defaults.object(forKey: K.userId) as? Int
        let username = defaults.string(forKey: K.username)
        let fullName = defaults.string(forKey: K.fullName)
        let businessId = defaults.object(forKey: K.businessId) as? Int
        let businessTypeId = defaults.object(forKey: K.businessTypeId) as? Int
        let permissions: [String] = {
            if let data = defaults.data(forKey: K.permissions),
               let arr = try? JSONDecoder().decode([String].self, from: data) { return arr }
            return []
        }()
        
        let snap = AuthSnapshot(
            accessToken: access,
            refreshToken: refresh,
            userId: userId,
            username: username,
            fullName: fullName,
            businessId: businessId,
            businessTypeId: businessTypeId,
            permissions: permissions
        )
        self.snapshot = snap
        self.initialSnapshot = snap
        self.subject = CurrentValueSubject(snap)
    }
    
    // Store entire Session (write-through; persist off-main)
    public func storeUserSession(
        accessToken: String,
        refreshToken: String,
        userId: Int,
        username: String,
        fullName: String,
        businessId: Int?,
        businessTypeId: Int?,
        permissions: [String]
    ) {
        // update cache
        snapshot.accessToken = accessToken
        snapshot.refreshToken = refreshToken
        snapshot.userId = userId
        snapshot.username = username
        snapshot.fullName = fullName
        snapshot.businessId = businessId
        snapshot.businessTypeId = businessTypeId
        snapshot.permissions = permissions
        
        // persist off-main (nu blocam UI)
        Task.detached { [defaults, service] in
            try? Keychain.set(accessToken, key: K.accessToken, service: service)
            try? Keychain.set(refreshToken, key: K.refreshToken, service: service)
            
            defaults.set(userId, forKey: K.userId)
            defaults.set(username, forKey: K.username)
            defaults.set(fullName, forKey: K.fullName)
            
            if let businessId { defaults.set(businessId, forKey: K.businessId) }
            else { defaults.removeObject(forKey: K.businessId) }
            
            if let businessTypeId { defaults.set(businessTypeId, forKey: K.businessTypeId) }
            else { defaults.removeObject(forKey: K.businessTypeId) }
            
            if let data = try? JSONEncoder().encode(permissions) {
                defaults.set(data, forKey: K.permissions)
            }
        }
    }
    
    public func current() -> AuthSnapshot { snapshot }
    
    public func refreshTokens(accessToken: String, refreshToken: String) {
        snapshot.accessToken = accessToken
        snapshot.refreshToken = refreshToken
        subject.send(snapshot)
        
        Task.detached { [service] in
            try? Keychain.set(accessToken, key: K.accessToken, service: service)
            try? Keychain.set(refreshToken, key: K.refreshToken, service: service)
        }
    }
    
    public func setBusinessId(_ businessId: Int?) {
        snapshot.businessId = businessId
        subject.send(snapshot)
        
        Task.detached { [defaults] in
            if let businessId { defaults.set(businessId, forKey: K.businessId) }
            else { defaults.removeObject(forKey: K.businessId) }
        }
    }
    
    public func setBusinessTypeId(_ businessTypeId: Int?) {
        snapshot.businessTypeId = businessTypeId
        subject.send(snapshot)
        
        Task.detached { [defaults] in
            if let businessTypeId { defaults.set(businessTypeId, forKey: K.businessTypeId) }
            else { defaults.removeObject(forKey: K.businessTypeId) }
        }
    }
    
    public func clearUserSession() {
        snapshot = AuthSnapshot(
            accessToken: nil,
            refreshToken: nil,
            userId: nil,
            username: nil,
            fullName: nil,
            businessId: nil,
            businessTypeId: nil,
            permissions: []
        )
        subject.send(snapshot)
        
        Task.detached { [defaults, service] in
            try? Keychain.set(nil, key: K.accessToken, service: service)
            try? Keychain.set(nil, key: K.refreshToken, service: service)
            
            [K.userId, K.username, K.fullName, K.businessId, K.businessTypeId, K.permissions]
                .forEach { defaults.removeObject(forKey: $0) }
        }
    }
}
