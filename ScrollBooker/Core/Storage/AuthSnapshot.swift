//
//  AuthSnapshot.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct AuthSnapshot: Equatable {
    var accessToken: String?
    var refreshToken: String?
    var cachedUserInfo: UserInfo?
    var permissions: [String]

    var isAuthenticated: Bool { accessToken?.isEmpty == false }

    init(
        accessToken: String? = nil,
        refreshToken: String? = nil,
        cachedUserInfo: UserInfo? = nil,
        permissions: [String] = []
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.cachedUserInfo = cachedUserInfo
        self.permissions = permissions
    }
}
