//
//  UserAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

/// Protocol decuplat de sesiuni, similar interfețelor curate din Retrofit / Jetpack Compose.
protocol UserAPI: Sendable {
    func userInfo() async throws -> UserInfo
    func userPermission() async throws -> [Permission]
}

final class UserAPIImpl: UserAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func userInfo() async throws -> UserInfo {
        let dto: UserInfoDTO = try await client.request("auth/user-info")
        
        return UserInfo(dto: dto)
    }
    
    func userPermission() async throws -> [Permission] {
        // Apel simplu, curat, fără management manual de token-uri.
        return try await client.request("auth/user-permissions")
    }
}
