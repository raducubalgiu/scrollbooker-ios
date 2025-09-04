//
//  AuthSnapshot.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

public struct AuthSnapshot: Equatable {
    public var accessToken: String?
    public var refreshToken: String?
    public var userId: Int?
    public var username: String?
    public var fullName: String?
    public var businessId: Int?
    public var businessTypeId: Int?
    public var permissions: [String]
    
    public var isAuthenticated: Bool { accessToken?.isEmpty == false }
    
    public init(accessToken: String? = nil, refreshToken: String? = nil, userId: Int? = nil, username: String? = nil, fullName: String? = nil, businessId: Int? = nil, businessTypeId: Int? = nil, permissions: [String]) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        self.username = username
        self.fullName = fullName
        self.businessId = businessId
        self.businessTypeId = businessTypeId
        self.permissions = permissions
    }
}
