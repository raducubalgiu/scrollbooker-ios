//
//  UserAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

protocol UserAPI {
    func userInfo(token: String) async throws -> UserInfo
    func userPermission(token: String) async throws -> [Permission]
}

final class UserAPIImpl: UserAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func userInfo(token: String) async throws -> UserInfo {
        let dto: UserInfoDTO = try await client.request(
            "auth/user-info",
            bearer: token
        )
        
        return UserInfo(dto: dto)
    }
    
    func userPermission(token: String) async throws -> [Permission] {
        return try await client.request(
            "auth/user-permissions",
            bearer: token
        )
    }
}
